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
    enableGlobalCompInit = false;
    promptInit = "";
  };

  programs.nano.enable = false;
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  users.users.acotten = with pkgs; {
    shell = zsh;
    packages = [
      git
      gnumake
      curl
      tree
      fzf
      zoxide
      file
    ];
  };
}
