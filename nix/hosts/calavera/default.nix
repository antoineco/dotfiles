{
  config,
  lib,
  pkgs,
  hardware,
  ...
}:
let
  k8s = config.services.kubernetes;
in
{
  imports = [
    ./hardware-configuration.nix
    hardware.nixosModules.lenovo-thinkpad-t490s

    ../../modules/profiles/nixos.nix
    ../../modules/profiles/workstation.nix

    ./kanata.nix
  ];

  networking.hostName = "calavera";

  environment.systemPackages = [ pkgs.slack ];

  users.users.acotten.packages = with pkgs; [
    claude-code
    cheat
    gh

    kubectl

    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.beta ])
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
  users.users.acotten.extraGroups = [ "docker" ];

  services.tailscale.enable = true;
  systemd.services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=auto" ];

  services.udev.extraRules =
    let
      runPrg = pkgs.writeShellScript "set-camera-controls" ''
        ${pkgs.v4l-utils}/bin/v4l2-ctl -d /dev/"$1" --set-ctrl focus_automatic_continuous=0
        ${pkgs.v4l-utils}/bin/v4l2-ctl -d /dev/"$1" --set-ctrl focus_absolute=0
      '';
    in
    ''
      # Logi C920/C920e webcams
      ACTION=="add", SUBSYSTEM=="video4linux", KERNEL=="video[0-9]*", ENV{ID_V4L_CAPABILITIES}=="*:capture:*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0892", RUN+="${runPrg} %k"
      ACTION=="add", SUBSYSTEM=="video4linux", KERNEL=="video[0-9]*", ENV{ID_V4L_CAPABILITIES}=="*:capture:*", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="08b6", RUN+="${runPrg} %k"
    '';

  services.kubernetes = {
    roles = [
      "master"
      "node"
    ];
    masterAddress = "localhost";

    kubelet.extraConfig = {
      failSwapOn = false;
      memorySwap.swapBehavior = "NoSwap";
    };

    addons.dns.replicas = 1;
  };

  systemd.targets.kubernetes.wantedBy = lib.mkForce [ ];
  systemd.services = {
    etcd.wantedBy = lib.mkForce [ "kube-apiserver.service" ];
    containerd.wantedBy = lib.mkForce [ "kubelet.service" ];
    flannel.wantedBy = lib.mkForce [ "kubelet.service" ];
    certmgr.wantedBy = lib.mkForce [ ];
  };

  # Admin cert owned by regular user
  # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/cluster/kubernetes/apiserver.nix#L529-L536
  services.kubernetes.pki.certs.acotten = k8s.lib.mkCert {
    name = "acotten";
    CN = "acotten";
    fields.O = "system:masters";
    privateKeyOwner = "acotten";
  };
  # Admin kubeconfig for regular user
  # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/services/cluster/kubernetes/default.nix#L286
  environment.etc."kubernetes/acotten.kubeconfig".source =
    with k8s.pki.certs.acotten;
    k8s.lib.mkKubeConfig "acotten" {
      server = k8s.apiserverAddress;
      certFile = cert;
      keyFile = key;
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}
