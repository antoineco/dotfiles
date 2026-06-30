{
  lib,
  pkgs,
  configDir ? ../../../zmk,
  zmk,
  zmk-helpers,
}:
let
  inherit (import ./lib.nix { inherit pkgs zmk configDir; }) firmware zmkForFileset;

  zmk' = zmkForFileset [
    (configDir + /glove80.keymap)
    (configDir + /glove80.conf)
    (lib.fileset.fileFilter (file: file.hasExt "h" || file.hasExt "dtsi") configDir)
  ];

  overrides = {
    extraModules = [ zmk-helpers ];
  };

  left = zmk'.override (overrides // { board = "glove80_lh"; });
  right = zmk'.override (overrides // { board = "glove80_rh"; });
in
firmware.combine_uf2 left right "glove80"
