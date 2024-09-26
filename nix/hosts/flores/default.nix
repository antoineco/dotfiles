{ disko, agenix, ... }:
{
  imports = [
    disko.nixosModules.disko
    ./disk.nix

    ../../modules/profiles/nixos.nix
    ./openstack.nix

    agenix.nixosModules.default
    ./wireguard.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  users.users.acotten = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrWkMRdF5phpLftdUHIgcSnSIKunqBecVN1jgSkuz8H"
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  networking.useNetworkd = true;

  powerManagement.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
