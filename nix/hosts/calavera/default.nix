{ pkgs, nixos-wsl, ... }:
{
  imports = [
    ../../modules/profiles/nixos.nix
    ../../modules/profiles/workstation.nix

    nixos-wsl.nixosModules.default
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  wsl = {
    enable = true;
    defaultUser = "acotten";
  };

  users.users.acotten.packages = [ pkgs.keychain ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
