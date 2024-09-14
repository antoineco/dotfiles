{ determinate, ... }:
{
  imports = [
    determinate.nixosModules.default

    ./common.nix
  ];
}
