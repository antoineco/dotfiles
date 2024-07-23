{
  description = "System packages";

  inputs = {
    nixpkgs.url = "nixpkgs";
    neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, neovim-overlay }:
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
          ];
        };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default =
          pkgs.buildEnv {
            name = "system-packages";
            paths = with pkgs; [
              git
              gnumake
              curl
              jq
              yq
              fzf
              bat
              ripgrep
              neovim
            ];
          };
      });
    };
}
