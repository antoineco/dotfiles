{ pkgs, hardware, ... }:
{
  imports = [
    ./hardware-configuration.nix
    hardware.nixosModules.lenovo-thinkpad-t490s

    ../../modules/profiles/nixos.nix
    ../../modules/profiles/workstation.nix

    ./kanata.nix
  ];

  networking = {
    hostName = "calavera";
    networkmanager.enable = true;
  };

  hardware.bluetooth.enable = true;

  boot = {
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };
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
    ghostty
    google-chrome
    brightnessctl
    adwaita-icon-theme # use nwg-look program to apply
    polkit_gnome
    swaynotificationcenter
    wl-clipboard
  ];

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "acotten" ];
  };

  fonts.packages = with pkgs; [
    monolisa-plus
    nerd-fonts.symbols-only
    adwaita-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  programs.niri.enable = true;

  programs.waybar.enable = true;

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = "${pkgs.greetd}/bin/agreety --cmd 'niri-session -l'";
  };

  systemd.packages = with pkgs; [
    swaynotificationcenter
  ];
  services.dbus.packages = [
    pkgs.swaynotificationcenter
  ];

  systemd.user.services.swaync.wantedBy = [ "graphical-session.target" ];

  systemd.user.services.swaybg = {
    description = "Wallpaper tool for Wayland compositors.";
    documentation = [ "https://github.com/swaywm/swaybg" ];
    partOf = [ "graphical-session.target" ];
    requires = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    unitConfig = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i %h/wall.jpg -m fill";
      Restart = "on-failure";
    };
    wantedBy = [ "graphical-session.target" ];
  };

  # Registers the GNOME Keyring and gcr D-Bus services.
  # Additionally enables the gcr-ssh-agent user service and the integration between the greetd PAM service and gnome-keyring.
  services.gnome.gnome-keyring.enable = true;

  # Registers the Seahorse D-Bus service and sets SSH_ASKPASS to Seahorse's prompt.
  programs.seahorse.enable = true;

  # Enables the pam_fprintd module (fprintAuth) for all registered PAM services (security.pam.services.<name>).
  services.fprintd.enable = true;
  # The password must be entered for gnome-keyring to be auto-unlocked.
  security.pam.services.greetd.fprintAuth = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}
