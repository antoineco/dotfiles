# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405"; # nixos-24.05
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # nixpkgs-unstable

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "nixos-wsl/flake-utils";
        flake-compat.follows = "";
      };
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/nix/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-compat.follows = "";
      };
    };

    rust-overlay = {
      url = "https://flakehub.com/f/oxalica/rust-overlay/0.1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "https://flakehub.com/f/nix-community/disko/1.7";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-wsl,
      nix-darwin,
      mac-app-util,
      determinate,
      neovim-overlay,
      rust-overlay,
      disko,
      flake-schemas,
    }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems =
        f: nixpkgs.lib.genAttrs allSystems (system: f { pkgs = nixpkgs.legacyPackages.${system}; });
    in
    {
      inherit (flake-schemas) schemas;

      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-rfc-style);

      packages = forAllSystems (
        { pkgs }:
        {
          nix-direnv =
            with pkgs;
            callPackage ./nix/pkgs/nix-direnv {
              # nix-direnv 3.0.5 uses a hardcoded path to the 'nix' executable
              # corresponding to the package's nix input. As of NixOS 24.05,
              # this nix input is a few versions behind the one from the
              # determinate input flake.
              # Note that version 3.0.6 addresses this by attempting to use the
              # ambient 'nix' executable first, before falling back to the
              # bundled one (nix-community/nix-direnv#513).
              nix = determinate.packages.${system}.default;
            };
          wezterm =
            with pkgs;
            callPackage ./nix/pkgs/wezterm {
              # error: package `bitstream-io v2.5.0` cannot be built because it requires
              # rustc 1.79 or newer, while the currently active rustc version is 1.77.2
              inherit (nixpkgs-unstable.legacyPackages.${system}) rustPlatform;
            };
        }
      );

      devShells = forAllSystems (
        { pkgs }:
        {
          nix =
            with pkgs;
            mkShell {
              name = "nix";
              packages = [
                nixfmt-rfc-style
                nixpkgs-unstable.legacyPackages.${system}.nixd
                nixpkgs-unstable.legacyPackages.${system}.fh
              ];
            };

          go =
            with pkgs;
            mkShell {
              name = "go";
              packages = [
                go
                gopls
                golangci-lint
                gofumpt
                delve
                gomodifytags
                gotests
                impl
              ];
            };

          rust =
            with pkgs;
            mkShell {
              name = "rust";
              packages = [ rust-overlay.packages.${system}.default ];
            };
        }
      );

      nixosConfigurations = {
        calavera = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit determinate neovim-overlay nixos-wsl;
            inherit (self) packages;
          };
          modules = [ ./nix/hosts/calavera ];
        };

        flores = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit determinate disko;
          };
          modules = [ ./nix/hosts/flores ];
        };
      };

      darwinConfigurations = {
        colomar = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit determinate neovim-overlay mac-app-util;
            inherit (self) packages;
          };
          modules = [ ./nix/hosts/colomar ];
        };
      };
    };
}
