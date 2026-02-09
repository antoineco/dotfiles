{
  pkgs,
  lib,
  hardware,
  monolisa,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    hardware.nixosModules.lenovo-thinkpad-t490s

    ../../modules/profiles/nixos.nix
    ../../modules/profiles/workstation.nix

    ./kanata.nix
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";

    overlays = [ monolisa.overlays.default ];

    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "monolisa-plus"
      ];
  };

  networking = {
    hostName = "calavera";
    networkmanager.enable = true;
  };

  hardware.bluetooth.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
  };

  time.timeZone = "Europe/Berlin";

  users.users.acotten = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video" # brightness control
    ];
  };

  environment.systemPackages = with pkgs; [
    wezterm
    firefox
    brightnessctl
    polkit_gnome # gnome-keyring integration
    adwaita-icon-theme # use nwg-look program to apply
    swaynotificationcenter
    hyprpaper
  ];

  fonts.packages = with pkgs; [
    monolisa-plus
    nerd-fonts.symbols-only
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = "${pkgs.greetd}/bin/agreety --cmd 'uwsm start hyprland-uwsm.desktop'";
  };
  programs.waybar.enable = true;

  systemd.packages = with pkgs; [
    swaynotificationcenter
    hyprpaper
  ];
  services.dbus.packages = [
    pkgs.swaynotificationcenter
  ];

  systemd.user.services = {
    swaync.wantedBy = [ "graphical-session.target" ];
    hyprpaper.wantedBy = [ "graphical-session.target" ];
  };

  # Registers the GNOME Keyring and gcr D-Bus services.
  # Additionally enables the gcr-ssh-agent user service and the integration between greetd and gnome-keyring.
  services.gnome.gnome-keyring.enable = true;

  # Registers the Seahorse D-Bus service and sets SSH_ASKPASS to Seahorse's prompt.
  programs.seahorse.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}
