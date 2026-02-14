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

    overlays = [
      monolisa.overlays.default

      (final: prev: {
        polkit_gnome = prev.polkit_gnome.overrideAttrs {
          # allow xdg-autostart in XDG_CURRENT_DESKTOP=niri
          postFixup = ''
            substituteInPlace "$out"/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop \
              --replace-fail "GNOME;" "niri;GNOME;"
          '';
        };
      })
    ];

    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "monolisa-plus"
        "google-chrome"
        "1password"
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
    google-chrome
    brightnessctl
    adwaita-icon-theme # use nwg-look program to apply
    polkit_gnome
    swaynotificationcenter
  ];

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "acotten" ];
  };

  fonts.packages = with pkgs; [
    monolisa-plus
    nerd-fonts.symbols-only
    adwaita-fonts
  ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };
  # The 'niri-session' startup script imports the entirety of the login manager's environment into systemd, so that it
  # becomes available to the niri.service unit (and other user services).
  # We must exclude a few of these environment variables, similarly to how uwsm does, mainly to avoid issues with
  # subshells spawned by terminal emulators inside Niri.
  #
  # Unfortunately, by creating this drop-in, the PATH environment variable gets forced by NixOS to a default value, and
  # most programs can no longer be launched by Niri.
  # This behavior will be opt-out in a future release via the 'enableDefaultPath' option (NixOS/nixpkgs#482045).
  # Meanwhile, this can be fixed manually by creating a drop-in via 'systemd --user edit niri.service'.
  #systemd.user.services.niri = {
  #  serviceConfig.UnsetEnvironment = [
  #    "SHLVL" # 1 (!)
  #    "SHELL" # /run/current-system/sw/bin/zsh
  #    "TERM" # linux
  #    "PWD" # $HOME
  #  ];
  #  enableDefaultPath = false;
  #};

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = "${pkgs.greetd}/bin/agreety --cmd 'niri-session -l'";
  };
  programs.waybar.enable = true;

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
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i %h/wall.jpg";
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
