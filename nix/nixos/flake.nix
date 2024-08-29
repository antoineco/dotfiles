# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.tar.gz"; # nixos-24.05

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl }: {
    nixosConfigurations = {
      calavera = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-wsl.nixosModules.default
          ({ pkgs, ... }: {
            nixpkgs.hostPlatform = "x86_64-linux";

            networking.hostName = "calavera";

            wsl = {
              enable = true;
              defaultUser = "acotten";
            };

            users.users.acotten.shell = pkgs.zsh;

            # This value determines the NixOS release from which the default
            # settings for stateful data, like file locations and database versions
            # on your system were taken. It's perfectly fine and recommended to leave
            # this value at the release version of the first install of this system.
            # Before changing this value read the documentation for this option
            # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
            system.stateVersion = "24.05";

            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            environment = {
              enableAllTerminfo = true;

              systemPackages = with pkgs; [
                keychain
              ];
            };

            programs.zsh.enable = true;
          })
        ];
      };
    };
  };
}
