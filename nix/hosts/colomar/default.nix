{ pkgs, ... }:
{
  imports = [
    ../../modules/profiles/darwin.nix
    ../../modules/profiles/workstation.nix

    ./system.nix
  ];

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

  environment = {
    shells = [ pkgs.zsh ];

    systemPackages = with pkgs; [
      wezterm
      ghostty-bin
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
