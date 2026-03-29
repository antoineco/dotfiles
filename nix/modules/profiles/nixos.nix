{ pkgs, determinate, ... }:
{
  imports = [
    determinate.nixosModules.default

    ./common.nix
  ];

  users.users.acotten.packages = with pkgs; [
    file
  ];
}
