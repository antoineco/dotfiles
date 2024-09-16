{ pkgs, ... }:
{
  wsl.extraBin = with pkgs; [
    # Required unconditionally to check that the WSL environment is conformant.
    { src = "${coreutils}/bin/cat"; }
    { src = "${coreutils}/bin/whoami"; }
    # Required to create the 'docker' group and add the WSL user to it.
    # These could alternatively be managed by NixOS.
    { src = "${shadow}/bin/groupadd"; }
    { src = "${shadow}/bin/usermod"; }
  ];

  users.users.acotten.packages = with pkgs; [
    # Compose links to Docker Desktop by opening 'docker-desktop://' URLs
    # through xdg-open.
    xdg-utils
  ];
}
