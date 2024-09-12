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
    packages.${pkgs.system}.nix-direnv
    neovim-overlay.packages.${pkgs.system}.default
  ];

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
