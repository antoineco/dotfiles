{ pkgs, ... }:
{
  nix.channel.enable = false;

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
