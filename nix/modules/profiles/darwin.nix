{ determinate, ... }:
{
  imports = [
    determinate.darwinModules.default

    ./common.nix
  ];

  nix.enable = false;
}
