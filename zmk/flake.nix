{
  description = "Zephyr build environment for ZMK keyboards";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # This pins requirements.txt provided by zephyr-nix.pythonEnv.
    zephyr.url = "github:zmkfirmware/zephyr/v3.5.0+zmk-fixes";
    zephyr.flake = false;

    # Zephyr SDK and toolchain.
    zephyr-nix.url = "github:nix-community/zephyr-nix";
    zephyr-nix.inputs.zephyr.follows = "zephyr";
    zephyr-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Glove80 ZMK fork with self-contained Zephyr toolchain.
    glove80-zmk.url = "github:moergo-sc/zmk?ref=v25.11";
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
    {
      devShells.x86_64-linux = {
        default =
          let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            zephyrPkgs = zephyr-nix.packages.x86_64-linux;
          in
          pkgs.mkShellNoCC {
            packages =
              (with pkgs; [
                cmake
                dtc
                ninja

                keymap-drawer
              ])
              ++ (with zephyrPkgs; [
                pythonEnv
                (sdk-0_16.override { targets = [ "arm-zephyr-eabi" ]; })
              ]);
          };
      };

      packages.x86_64-linux = {
        glove80 =
          let
            # Use moergo's pinned nixpkgs, but set 'system' explicitly because
            # 'builtins.currentSystem' is disabled in pure mode (the default).
            # https://github.com/moergo-sc/zmk/blob/v25.11/nix/pinned-nixpkgs.nix#L1
            firmware = import glove80-zmk {
              pkgs = import (glove80-zmk + /nix/pinned-nixpkgs.nix) { system = "x86_64-linux"; };
            };

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
      };
    };
}
