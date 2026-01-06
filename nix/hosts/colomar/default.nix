{
  pkgs,
  lib,
  monolisa,
  ...
}:
{
  imports = [
    ../../modules/profiles/darwin.nix
    ../../modules/profiles/workstation.nix

    ./system.nix
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";

    overlays = [ monolisa.overlays.default ];

    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "appcleaner"
        "betterdisplay"
        "monolisa-plus"
      ];
  };

  networking.hostName = "colomar";

  users = {
    knownUsers = [ "acotten" ];
    users.acotten = {
      uid = 501;
      packages = with pkgs; [
        colima
        docker-client
        amazon-ecr-credential-helper
      ];
    };
  };

  environment = with pkgs; {
    shells = [ zsh ];

    systemPackages = [
      wezterm
      appcleaner
      betterdisplay
    ];
  };

  fonts.packages = with pkgs; [
    monolisa-plus
    nerd-fonts.symbols-only
  ];

  # Used for backwards compatibility, similarly to NixOS.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or at https://daiderd.com/nix-darwin/manual/).
  system.stateVersion = 6;
}
