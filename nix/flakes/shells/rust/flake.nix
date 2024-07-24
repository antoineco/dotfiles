{
  description = "Rust development shell";

  inputs = {
    nixpkgs.url = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
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
