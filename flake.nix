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

    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nvim-treesitter-main.url = "github:iofq/nvim-treesitter-main";

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
      nixCats,
      neovim-overlay,
      nvim-treesitter-main,
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

      packages = forAllSystems (
        { pkgs }:
        let
          system = pkgs.stdenv.hostPlatform.system;

          dependencyOverlays = [
            # Overlays vimPlugins.{nvim-treesitter,nvim-treesitter-textobjects} with the revision
            # from their respective 'main' branch (full rewrite, incompatible with old 'master').
            nvim-treesitter-main.overlays.default
          ];

          categoryDefinitions =
            { pkgs, ... }:
            {
              startupPlugins = {
                general = [
                  pkgs.vimPlugins.nvim-treesitter-textobjects
                ]
                # Allow collate_grammars to collect grammars under the grammarPackName directory.
                # When using pkgs.vimPlugins.nvim-treesitter.withPlugins, grammars end up in the
                # packageName directory instead.
                ++ (with pkgs.tree-sitter-grammars; [
                  (pkgs.neovimUtils.grammarToPlugin tree-sitter-go)
                  (pkgs.neovimUtils.grammarToPlugin tree-sitter-rust)
                ]);
              };
            };

          packageDefinitions = {
            nvim =
              { ... }:
              {
                settings = {
                  wrapRc = false;
                  aliases = [ "vi" ];
                  neovim-unwrapped = neovim-overlay.packages.${system}.neovim;
                };
                categories = {
                  general = true;
                };
              };
          };

          luaPath = ./.;
          nixCatsBuilder = nixCats.utils.baseBuilder luaPath {
            inherit nixpkgs system dependencyOverlays;
          } categoryDefinitions packageDefinitions;

          defaultPackageName = "nvim";
          defaultPackage = nixCatsBuilder defaultPackageName;
        in
        nixCats.utils.mkAllPackages defaultPackage
      );

      nixosConfigurations = {
        calavera = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self determinate nixos-wsl; };
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
          specialArgs = { inherit self nixpkgs-unstable; };
          modules = [ ./nix/hosts/colomar ];
        };
      };
    };
}
