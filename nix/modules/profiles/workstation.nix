{ pkgs, self, ... }:
{
  nixpkgs.overlays = [ self.overlays.default ];

  users.users.acotten.packages = with pkgs; [
    jq
    yq-go
    bat
    ripgrep
    direnv
    nix-direnv
    neovim
  ];

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
