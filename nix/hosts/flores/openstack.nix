{ modulesPath, lib, ... }:
{
  imports = [ (modulesPath + "/virtualisation/openstack-config.nix") ];

  # force disko values
  fileSystems."/".device = lib.mkForce "/dev/disk/by-partlabel/disk-nixos-root";
  boot.loader.grub.device = lib.mkForce "";
}
