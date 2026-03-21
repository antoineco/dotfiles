{ pkgs, ... }:
{
  users.users.acotten.packages = with pkgs; [
    neovim
    jq
    yq-go
    bat
    difftastic
    ripgrep
    direnv
    nix-direnv
  ];

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
