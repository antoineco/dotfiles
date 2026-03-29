{ pkgs, ... }:
{
  nix.channel.enable = false;

  programs.zsh.enable = true;

  users.users.acotten = with pkgs; {
    shell = zsh;
    packages = [
      git
      gnumake
      curl
      tree
      fzf
    ];
  };
}
