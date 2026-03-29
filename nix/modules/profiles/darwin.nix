{ pkgs, determinate, ... }:
{
  imports = [
    determinate.darwinModules.default

    ./common.nix
  ];

  determinateNix.customSettings.trusted-users = [ "acotten" ];

  users.users.acotten.packages = with pkgs; [
    watch
  ];
}
