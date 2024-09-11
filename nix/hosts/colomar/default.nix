{ pkgs, packages, ... }:
{
  imports = [
    ../../modules/profiles/darwin.nix
    ../../modules/profiles/workstation.nix

    ./system.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

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
    systemPackages = [ packages.${pkgs.system}.wezterm ];
  };

  # Used for backwards compatibility, similarly to NixOS.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://daiderd.com/nix-darwin/manual/).
  system.stateVersion = 5;
}
