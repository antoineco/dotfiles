{ pkgs, neovim-overlay, ... }:
{
  users.users.acotten.packages = with pkgs; [
    jq
    yq-go
    bat
    ripgrep
    direnv
    nix-direnv
    neovim-overlay.packages.${system}.default
  ];
}
