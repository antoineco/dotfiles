{ pkgs, hardware, ... }:
{
  imports = [
    ./hardware-configuration.nix
    hardware.nixosModules.lenovo-thinkpad-t490s

    ../../modules/profiles/nixos.nix
    ../../modules/profiles/workstation.nix

    ./kanata.nix
  ];

  networking.hostName = "calavera";

  environment.systemPackages = [ pkgs.slack ];

  users.users.acotten.packages = with pkgs; [
    claude-code
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.beta ])
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}
