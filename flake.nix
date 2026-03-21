{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2511"; # nixos-25.11
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # nixos-unstable
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";

    rust-overlay.url = "https://flakehub.com/f/oxalica/rust-overlay/0.1";

    monolisa = {
      url = "git+ssh://git@github.com/antoineco/monolisa.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-schemas.follows = "flake-schemas";
      };
    };

    agenix.url = "github:ryantm/agenix";
    secrets = {
      url = "git+ssh://git@github.com/antoineco/nix-secrets.git";
      flake = false;
    };

    hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/0.1";
    disko.url = "https://flakehub.com/f/nix-community/disko/1.7";

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.3";
  };

  outputs =
    {
      nixpkgs,
      determinate,
      nix-darwin,
      agenix,
      secrets,
      hardware,
      disko,
      flake-schemas,
      ...
    }@inputs:
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
              overlays = [ (import ./nix/overlays inputs) ];
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      inherit (flake-schemas) schemas;

      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-tree);

      devShells = forAllSystems (
        { pkgs }:
        {
          default =
            with pkgs;
            mkShell {
              name = "dots";
              packages = [
                nixfmt-rfc-style
                nixd
                fh
                lua-language-server
                bash-language-server
              ];
            };

          go =
            with pkgs;
            mkShell {
              name = "go";
              packages = [
                go_1_26
                gopls
                golangci-lint
                gofumpt
                delve
                gomodifytags
                gotestsum
                gotests
                impl
              ];
            };

          rust =
            with pkgs;
            mkShell {
              name = "rust";
              packages =
                let
                  rust-stable-custom = rust-bin.stable.latest.default.override {
                    extensions = [
                      "rust-analyzer"
                      "rust-src"
                    ];
                  };
                in
                [
                  rust-stable-custom
                  vscode-extensions.vadimcn.vscode-lldb.adapter
                ];
            };
        }
      );

      nixosConfigurations = {
        calavera = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit determinate hardware;
          };
          modules = [
            ./nix/hosts/calavera
            { nixpkgs.pkgs = (forAllSystems ({ pkgs }: pkgs)).x86_64-linux; }
          ];
        };

        flores = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              determinate
              disko
              agenix
              secrets
              ;
          };
          modules = [
            ./nix/hosts/flores
            { nixpkgs.pkgs = (forAllSystems ({ pkgs }: pkgs)).x86_64-linux; }
          ];
        };
      };

      darwinConfigurations = {
        colomar = nix-darwin.lib.darwinSystem {
          modules = [
            ./nix/hosts/colomar
            { nixpkgs.pkgs = (forAllSystems ({ pkgs }: pkgs)).aarch64-darwin; }
          ];
        };
      };
    };
}
