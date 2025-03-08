{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2411"; # nixos-24.11
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
              (with pkgs; [
                gopls
                golangci-lint
                gofumpt
                gomodifytags
                gotests
                impl
              ])
              ++ (
                let
                  pkgs-unstable = determinate.inputs.nixpkgs.legacyPackages.${pkgs.system}; # nixpkgs-weekly
                in
                with pkgs-unstable;
                [ go_1_24 ]
                ++ (
                  let
                    delveGo124 = delve.override { buildGoModule = buildGo124Module; };
                  in
                  [ delveGo124 ]
                )
              );
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
                [ rust-stable-custom ];
            };
        }
      );

      nixosConfigurations = {
        calavera = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit determinate nixos-wsl;
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
          modules = [ ./nix/hosts/colomar ];
        };
      };
    };
}
