{ pkgs, ... }:
{
  nix = {
    channel.enable = false;
    settings.trusted-users = [ "acotten" ];
  };

  environment.systemPackages = [ pkgs.pkgsBuildBuild.wezterm.terminfo ];

  programs.zsh.enable = true;

  users.users.acotten = with pkgs; {
    shell = zsh;
    packages = [
      git
      gnumake
      curl
      fzf
    ];
  };
}
