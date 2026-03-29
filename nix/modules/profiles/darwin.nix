{ pkgs, determinate, ... }:
{
  imports = [
    determinate.darwinModules.default

    ./common.nix
  ];

  users.users.acotten.packages = with pkgs; [
    watch
  ];
}
