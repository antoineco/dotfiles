{ pkgs, self, ... }:
{
  nixpkgs.overlays = [ self.overlays.default ];

  users.users.acotten.packages = with pkgs; [
    neovim-nixCats
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
