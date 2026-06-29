{
  description = "Zephyr build environment for ZMK keyboards";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # nixos-unstable

    # This pins requirements.txt provided by zephyr-nix.pythonEnv.
    zephyr.url = "github:zmkfirmware/zephyr/v3.5.0+zmk-fixes";
    zephyr.flake = false;

    # Zephyr SDK and toolchain.
    zephyr-nix.url = "github:nix-community/zephyr-nix";
    zephyr-nix.inputs.zephyr.follows = "zephyr";

    # Moergo's ZMK fork with self-contained Zephyr toolchain.
    moergo-zmk.url = "github:moergo-sc/zmk?ref=v25.11";
    moergo-zmk.flake = false;

    zmk-helpers.url = "github:urob/zmk-helpers?ref=v0.3";
    zmk-helpers.flake = false;
  };

  outputs =
    {
      nixpkgs,
      zephyr-nix,
      moergo-zmk,
      zmk-helpers,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      devShells.x86_64-linux = {
        default =
          let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            zephyrPkgs = zephyr-nix.packages.x86_64-linux;
          in
          pkgs.mkShellNoCC {
            name = "zephyr";
            packages =
              (with pkgs; [
                cmake
                dtc
                ninja

                keymap-drawer

                nixfmt
                nixd
                fh
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
            pkgs = import (moergo-zmk + /nix/pinned-nixpkgs.nix) { system = "x86_64-linux"; };
            firmware = import moergo-zmk { inherit pkgs; };

            config =
              let
                inherit (pkgs) lib;
                dir = ./config;
              in
              lib.fileset.toSource {
                root = dir;
                fileset = lib.fileset.unions [
                  (dir + /glove80.keymap)
                  (dir + /glove80.conf)
                  (lib.fileset.fileFilter (file: file.hasExt "h" || file.hasExt "dtsi") dir)
                ];
              };

            overrides = {
              keymap = "${config}/glove80.keymap";
              kconfig = "${config}/glove80.conf";
              extraModules = [ zmk-helpers ];
            };

            left = firmware.zmk.override (overrides // { board = "glove80_lh"; });
            right = firmware.zmk.override (overrides // { board = "glove80_rh"; });
          in
          firmware.combine_uf2 left right "glove80";
      };
    };
}
