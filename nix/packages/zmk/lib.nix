{
  pkgs,
  zmk,
  configDir,
}:
let
  firmware = import zmk {
    pkgs = import (zmk + /nix/pinned-nixpkgs.nix) { inherit (pkgs.stdenv.hostPlatform) system; };
  };
in
{
  inherit firmware;

  zmkForFileset =
    fs:
    let
      dir = pkgs.lib.fileset.toSource {
        root = configDir;
        fileset = pkgs.lib.fileset.unions fs;
      };
    in
    firmware.zmk.overrideAttrs (prev: {
      cmakeFlags =
        # ZMK's keymap-module already appends the app dir to BOARD_ROOT.
        # This results in a duplicated <board>.overlay file, which causes ninja to fail.
        pkgs.lib.filter (f: f != "-DBOARD_ROOT=.") prev.cmakeFlags
        ++
        # Let ZMK's keymap-module discover the shield's keymap and conf file(s)
        # from its config store path, instead of passing all explictly via overrides.
        [ "-DZMK_CONFIG=${dir}" ];
    });
}
