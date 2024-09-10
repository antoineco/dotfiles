{ determinate, ... }:
{
  imports = [
    determinate.darwinModules.default

    ./common.nix
  ];

  programs.zsh.shellInit = ''(( ''${+NIX_PATH} )) && [[ -z ''${NIX_PATH} ]] && unset NIX_PATH'';
}
