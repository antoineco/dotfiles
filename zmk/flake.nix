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
        in
        {
          totem =
            let
              config = configSource (
                lib.fileset.unions [
                  (configDir + /totem.keymap)
                  (lib.fileset.fileFilter (file: file.hasExt "conf" && lib.hasPrefix "totem" file.name) configDir)
                  (lib.fileset.fileFilter (file: file.hasExt "h" || file.hasExt "dtsi") configDir)
                ]
              );

              overrides = {
                keymap = "${config}/totem.keymap";
                board = "seeeduino_xiao_ble";
                extraModules = [
                  zmk-helpers
                  zmk-totem
                ];
              };

              # ZMK's keymap-module already appends the app dir to BOARD_ROOT.
              # This results in a duplicated seeeduino_xiao_ble.overlay file,
              # which causes ninja to fail.
              zmk = firmware.zmk.overrideAttrs (prev: {
                cmakeFlags = lib.filter (f: f != "-DBOARD_ROOT=.") prev.cmakeFlags;
              });

              left = zmk.override (
                overrides
                // {
                  shield = "totem_left";
                  kconfig = "${config}/totem.conf;${config}/totem_left.conf";
                }
              );
              right = zmk.override (
                overrides
                // {
                  shield = "totem_right";
                  kconfig = "${config}/totem.conf;${config}/totem_right.conf";
                }
              );
            in
            pkgs.runCommandNoCC "zmk_totem" { } ''
              install -Dm444 ${left}/zmk.uf2 $out/totem_left.uf2
              install -Dm444 ${right}/zmk.uf2 $out/totem_right.uf2
            '';

          glove80 =
            let
              config = configSource (
                lib.fileset.unions [
                  (configDir + /glove80.keymap)
                  (configDir + /glove80.conf)
                  (lib.fileset.fileFilter (file: file.hasExt "h" || file.hasExt "dtsi") configDir)
                ]
              );

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
