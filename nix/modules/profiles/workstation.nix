{ pkgs, nixpkgs-unstable, ... }:
{
  users.users.acotten.packages =
    (with pkgs; [
      jq
      yq-go
      bat
      ripgrep
      direnv
      nix-direnv
    ])
    ++ (with nixpkgs-unstable.legacyPackages.${pkgs.system}; [
      neovim
    ]);

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
