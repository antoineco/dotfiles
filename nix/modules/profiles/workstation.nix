{ pkgs, self, ... }:
{
  users.users.acotten.packages =
    (with pkgs; [
      jq
      yq-go
      bat
      difftastic
      ripgrep
      direnv
      nix-direnv
    ])
    ++ [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
