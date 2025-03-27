{ pkgs, nixos-unstable-small, ... }:
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
    ++ (with nixos-unstable-small.legacyPackages.${pkgs.system}; [
      neovim
    ]);

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
