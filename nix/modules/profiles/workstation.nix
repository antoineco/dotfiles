{ pkgs, neovim-overlay, ... }:
{
  nixpkgs.overlays = [ neovim-overlay.overlays.default ];

  users.users.acotten.packages = with pkgs; [
    jq
    yq-go
    bat
    difftastic
    ripgrep
    direnv
    nix-direnv
    neovim
    tree-sitter
  ];

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
