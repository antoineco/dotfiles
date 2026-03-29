{ pkgs, determinate, ... }:
{
  imports = [
    determinate.nixosModules.default

    ./common.nix
  ];

  nix.settings.trusted-users = [ "acotten" ];

  users.users.acotten.packages = with pkgs; [
    file
  ];
}
