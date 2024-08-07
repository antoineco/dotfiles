{
  description = "System packages and generic development shells";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.tar.gz"; # nixos-unstable

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "https://flakehub.com/f/oxalica/rust-overlay/0.1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1.*.tar.gz";
  };

  outputs = { self, nixpkgs, neovim-overlay, rust-overlay, flake-schemas }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # Expands to an attribute set where each name ('system' argument)
      # corresponds to an entry in the allSystems list, and each value is
      # dynamically expanded to the result of applying the function 'f' to an
      # arbitrary function with an attribute set argument {pkgs}, where pkgs
      # becomes an attribute set of *all* nixpkgs packages for the evaluated
      # 'system' argument ('import nixpkgs' evaluates to a lambda).
      #
      # Cheat sheet:
      #
      #   genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: "x_" + system )
      #   => { x86_64-linux = "x_86_64-linux"; aarch64-darwin = "x_aarch64-darwin"; }
      #
      #   (f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: f { pkgs = [ ("x_" + system) ]; })) ({ pkgs }: { default = pkgs; })
      #   => { x86_64-linux = { default = [ "x_86_64-linux" ]; }; aarch64-darwin = { default = [ "x_aarch64-darwin" ]; }; }
      #
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neovim-overlay.overlays.default
            rust-overlay.overlays.default
          ];
        };
      });
    in
    {
      inherit (flake-schemas) schemas;

      packages = forAllSystems ({ pkgs }: {
        default = with pkgs; buildEnv {
          name = "system-packages";
          paths = [
            git
            gnumake
            curl
            jq
            yq-go
            fzf
            bat
            ripgrep
            neovim
          ];
        };
      });

      devShells = forAllSystems ({ pkgs }: {
        go = with pkgs; mkShell {
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

        rust = with pkgs; mkShell {
          name = "rust";
          packages = [
            rust-bin.stable.latest.default
          ];
        };
      });
    };
}
