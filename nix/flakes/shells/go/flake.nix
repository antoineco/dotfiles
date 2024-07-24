{
  description = "Go development shell";

  inputs.nixpkgs.url = "nixpkgs";

  outputs = { self, nixpkgs }:
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
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          name = "go-shell";
          packages = with pkgs; [
            go
            gopls
            golangci-lint
            gomodifytags
            gotests
            impl
          ];
        };
      });
    };
}
