{ pkgs, determinate, ... }:
{
  imports = [
    determinate.nixosModules.default
  ];

  nix = {
    channel.enable = false;
    settings.trusted-users = [ "acotten" ];
  };

  programs.zsh.enable = true;

  users.users.acotten = with pkgs; {
    shell = zsh;
    packages = [
      git
      gnumake
      curl
      tree
      fzf
      file
    ];
  };
}
