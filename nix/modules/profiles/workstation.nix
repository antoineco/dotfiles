{
  pkgs,
  packages,
  neovim-overlay,
  ...
}:
{
  users.users.acotten.packages = with pkgs; [
    jq
    yq-go
    bat
    ripgrep
    direnv
    packages.${system}.nix-direnv
    neovim-overlay.packages.${system}.default
  ];

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
