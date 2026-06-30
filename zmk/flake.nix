{
  description = "ZMK keyboards";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # nixos-unstable

    # Moergo's ZMK fork with self-contained Zephyr toolchain.
    moergo-zmk.url = "github:moergo-sc/zmk?ref=v25.11";
    moergo-zmk.flake = false;

    zmk-helpers.url = "github:urob/zmk-helpers?ref=v0.3";
    zmk-helpers.flake = false;

    zmk-totem.url = "github:antoineco/zmk-keyboard-totem?ref=v0.3";
    zmk-totem.flake = false;
  };

  outputs =
    {
      nixpkgs,
      moergo-zmk,
      zmk-helpers,
      zmk-totem,
      ...
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      devShells.x86_64-linux = {
        default =
          with nixpkgs.legacyPackages.x86_64-linux;
          mkShellNoCC {
            name = "zephyr";
            packages = [
              keymap-drawer

              nixfmt
              nixd
              fh
            ];
          };
      };

      packages.x86_64-linux =
        let
          # Use moergo's pinned nixpkgs, but set 'system' explicitly because
          # 'builtins.currentSystem' is disabled in pure mode (the default).
          # https://github.com/moergo-sc/zmk/blob/v25.11/nix/pinned-nixpkgs.nix#L1
          pkgs = import (moergo-zmk + /nix/pinned-nixpkgs.nix) { system = "x86_64-linux"; };
          firmware = import moergo-zmk { inherit pkgs; };

          inherit (pkgs) lib;

          configDir = ./config;
          configSource =
            fs:
            lib.fileset.toSource {
              root = configDir;
              fileset = fs;
            };

          zmk =
            configDir:
            firmware.zmk.overrideAttrs (prev: {
              cmakeFlags =
                # ZMK's keymap-module already appends the app dir to BOARD_ROOT.
                # This results in a duplicated <board>.overlay file, which
                # causes ninja to fail.
                lib.filter (f: f != "-DBOARD_ROOT=.") prev.cmakeFlags
                ++
                # Let ZMK's keymap-module discover the shield's keymap and conf
                # file(s) from its config store path, instead of passing all
                # explictly via overrides.
                [ "-DZMK_CONFIG=${configDir}" ];
            });
        in
        {
          totem =
            let
              zmk' = zmk (
                configSource (
                  lib.fileset.unions [
                    (configDir + /totem.keymap)
                    (lib.fileset.fileFilter (file: file.hasExt "conf" && lib.hasPrefix "totem" file.name) configDir)
                    (lib.fileset.fileFilter (file: file.hasExt "h" || file.hasExt "dtsi") configDir)
                  ]
                )
              );

              overrides = {
                board = "seeeduino_xiao_ble";
                extraModules = [
                  zmk-helpers
                  zmk-totem
                ];
              };

              left = zmk'.override (overrides // { shield = "totem_left"; });
              right = zmk'.override (overrides // { shield = "totem_right"; });
            in
            pkgs.runCommandNoCC "zmk_totem" { } ''
              install -Dm444 ${left}/zmk.uf2 $out/totem_left.uf2
              install -Dm444 ${right}/zmk.uf2 $out/totem_right.uf2
            '';

          glove80 =
            let
              zmk' = zmk (
                configSource (
                  lib.fileset.unions [
                    (configDir + /glove80.keymap)
                    (configDir + /glove80.conf)
                    (lib.fileset.fileFilter (file: file.hasExt "h" || file.hasExt "dtsi") configDir)
                  ]
                )
              );

              overrides = {
                extraModules = [ zmk-helpers ];
              };

              left = zmk'.override (overrides // { board = "glove80_lh"; });
              right = zmk'.override (overrides // { board = "glove80_rh"; });
            in
            firmware.combine_uf2 left right "glove80";
        };
    };
}
