{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405"; # nixos-24.05
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "determinate/nixpkgs";
        flake-compat.follows = "";
      };
    };

    rust-overlay = {
      url = "https://flakehub.com/f/oxalica/rust-overlay/0.1";
      inputs.nixpkgs.follows = "determinate/nixpkgs";
    };

    disko = {
      url = "https://flakehub.com/f/nix-community/disko/1.7";
      inputs.nixpkgs.follows = "determinate/nixpkgs";
    };

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      nix-darwin,
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
        f:
        nixpkgs.lib.genAttrs allSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                self.overlays.default
                rust-overlay.overlays.default
                # Fails to overlay on top of nixos-24.05 (nix-community/neovim-nightly-overlay#533)
                #neovim-overlay.overlays.default
              ];
            };
          }
        );
    in
    {
      inherit (flake-schemas) schemas;

      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-rfc-style);

      overlays.default =
        _: super:
        let
          inherit (super) system;
        in
        (with determinate.inputs.nixpkgs.legacyPackages.${system}; {
          nixd = nixd;
          fh = fh;
        })
        // (with neovim-overlay.packages.${system}; {
          neovim-nightly = default;
        })
        // (with determinate.inputs.nix.packages.${system}; {
          # nix-direnv 3.0.5 uses a hardcoded path to the nix executable
          # corresponding to the package's 'nix' input. As of NixOS 24.05,
          # this 'nix' input is a few versions behind the one from the
          # determinate input flake.
          # Note that version 3.0.6 addresses this by attempting to use the
          # ambient nix executable first, before falling back to the bundled
          # one (nix-community/nix-direnv#513).
          nix = default;
        });

      devShells = forAllSystems (
        { pkgs }:
        {
          nix =
            with pkgs;
            mkShell {
              name = "nix";
              packages = [
                nixfmt-rfc-style
                nixd
                fh
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
              packages = [ rust-bin.stable.latest.default ];
            };
        }
      );

      nixosConfigurations = {
        calavera = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self determinate nixos-wsl;
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
            inherit self determinate;
          };
          modules = [ ./nix/hosts/colomar ];
        };
      };
    };
}
