{ pkgs, neovim-overlay, ... }:
{
  users.users.acotten.packages = with pkgs; [
    jq
    yq-go
    bat
    ripgrep
    neovim-overlay.packages.${system}.default
  ];
}
