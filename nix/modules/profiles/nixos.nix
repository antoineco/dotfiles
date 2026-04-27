{ pkgs, determinate, ... }:
{
  imports = [
    determinate.nixosModules.default
  ];

  nix = {
    channel.enable = false;
    settings.trusted-users = [ "acotten" ];
  };

  programs.zsh = {
    enable = true;

    # done by Zim
    enableCompletion = false;
    promptInit = "";
  };

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
