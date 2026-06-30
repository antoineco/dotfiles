{
  lib,
  pkgs,
  runCommand,
  configDir ? ../../../zmk,
  zmk,
  zmk-helpers,
  zmk-totem,
}:
let
  inherit (import ./lib.nix { inherit pkgs zmk configDir; }) zmkForFileset;

  zmk' = zmkForFileset [
    (configDir + /totem.keymap)
    (lib.fileset.fileFilter (file: file.hasExt "conf" && lib.hasPrefix "totem" file.name) configDir)
    (lib.fileset.fileFilter (file: file.hasExt "h" || file.hasExt "dtsi") configDir)
  ];

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
runCommand "zmk_totem" { } ''
  install -Dm444 ${left}/zmk.uf2 $out/totem_left.uf2
  install -Dm444 ${right}/zmk.uf2 $out/totem_right.uf2
''
