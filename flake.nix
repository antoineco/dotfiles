{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2411"; # nixos-24.11
    nixpkgs-unstable.url = "nixpkgs";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.flake-compat.follows = "";
    };

    nix-darwin.url = "nix-darwin/nix-darwin-24.11";

    rust-overlay.url = "https://flakehub.com/f/oxalica/rust-overlay/0.1";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.home-manager.follows = "";
    };
    secrets = {
      url = "git+ssh://git@github.com/antoineco/nix-secrets.git";
      flake = false;
    };

    disko.url = "https://flakehub.com/f/nix-community/disko/1.7";

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-wsl,
      nix-darwin,
      determinate,
      rust-overlay,
      disko,
      agenix,
      secrets,
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
              overlays = [ rust-overlay.overlays.default ];
            };
          }
        );
    in
    {
      inherit (flake-schemas) schemas;

      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-rfc-style);

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

          go = pkgs.mkShell {
            name = "go";
            packages =
              let
                pkgs-unstable = nixpkgs-unstable.legacyPackages.${pkgs.system};
              in
              with pkgs-unstable;
              [
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
            inherit
              nixpkgs-unstable
              determinate
              nixos-wsl
              ;
          };
          modules = [ ./nix/hosts/calavera ];
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
          modules = [ ./nix/hosts/flores ];
        };
      };

      darwinConfigurations = {
        colomar = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit nixpkgs-unstable; };
          modules = [ ./nix/hosts/colomar ];
        };
      };
    };
}
