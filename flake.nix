{
  description = "System configurations for NixOS and macOS";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2505"; # nixos-25.05
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # nixos-unstable
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    nix-darwin = {
      url = "nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    rust-overlay.url = "https://flakehub.com/f/oxalica/rust-overlay/0.1";

    agenix.url = "github:ryantm/agenix";
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
      determinate,
      nixos-wsl,
      nix-darwin,
      neovim-overlay,
      rust-overlay,
      agenix,
      secrets,
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
              overlays = [ rust-overlay.overlays.default ];
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

          go = pkgs.mkShell {
            name = "go";
            packages =
              let
                pkgs-unstable = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
              in
              with pkgs-unstable;
              [
                go
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
            inherit
              determinate
              nixos-wsl
              neovim-overlay
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
          specialArgs = { inherit nixpkgs-unstable neovim-overlay; };
          modules = [ ./nix/hosts/colomar ];
        };
      };
    };
}
