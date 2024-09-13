{ determinate, mac-app-util, ... }:
{
  imports = [
    determinate.darwinModules.default
    mac-app-util.darwinModules.default

    ./common.nix
  ];
}
