{
  description = "Go development shell";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz"; # nixos-unstable
  inputs.flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/0.1.*.tar.gz";

  outputs = { self, nixpkgs, flake-schemas }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      inherit (flake-schemas) schemas;

      devShells = forAllSystems ({ pkgs }: {
        default = with pkgs; mkShell {
          name = "go-shell";
          packages = [
            go
            gopls
            golangci-lint
            delve
            gomodifytags
            gotests
            impl
          ];
        };
      });
    };
}
