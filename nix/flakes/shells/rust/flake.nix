{
  description = "Rust development shell";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz"; # nixos-unstable

    rust-overlay = {
      url = "https://flakehub.com/f/oxalica/rust-overlay/0.1.*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            rust-overlay.overlays.default
          ];
        };
      });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = with pkgs; mkShell {
          name = "rust-shell";
          packages = [
            rust-bin.stable.latest.default
          ];
        };
      });
    };
}