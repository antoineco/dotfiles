{
  description = "Zephyr build environment for ZMK keyboards";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # This pins requirements.txt provided by zephyr-nix.pythonEnv.
    zephyr.url = "github:zmkfirmware/zephyr/v3.5.0+zmk-fixes";
    zephyr.flake = false;

    # Zephyr SDK and toolchain.
    zephyr-nix.url = "github:adisbladis/zephyr-nix";
    zephyr-nix.inputs.zephyr.follows = "zephyr";
    zephyr-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Glove80 ZMK fork with self-contained Zephyr toolchain.
    glove80-zmk.url = "github:moergo-sc/zmk?ref=v25.08";
    glove80-zmk.flake = false;

    zmk-helpers.url = "github:urob/zmk-helpers?ref=v0.3";
    zmk-helpers.flake = false;
  };

  outputs =
    {
      nixpkgs,
      zephyr-nix,
      glove80-zmk,
      zmk-helpers,
      ...
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
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forAllSystems (
        { pkgs }:
        let
          zephyr = zephyr-nix.packages.${pkgs.system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [
              zephyr.pythonEnv
              (zephyr.sdk-0_16.override { targets = [ "arm-zephyr-eabi" ]; })

              pkgs.cmake
              pkgs.dtc
              pkgs.ninja
            ];
          };
        }
      );

      packages = forAllSystems (
        { pkgs }:
        {
          glove80 =
            let
              firmware = import glove80-zmk { inherit pkgs; };

              config = ./config;
              overrides = {
                keymap = "${config}/glove80.keymap";
                kconfig = "${config}/glove80.conf";
                extraModules = [ zmk-helpers ];
              };

              left = firmware.zmk.override (overrides // { board = "glove80_lh"; });
              right = firmware.zmk.override (overrides // { board = "glove80_rh"; });
            in
            firmware.combine_uf2 left right;
        }
      );
    };
}
