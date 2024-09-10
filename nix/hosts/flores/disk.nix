# Used by nixos-anywhere to partition the instance's disk during the OS
# provisioning phase.
{
  disko.devices.disk.nixos = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        # NOTE: disko automatically adds devices that have a EF02
        # partition to boot.loader.grub.devices
        boot = {
          size = "1M";
          type = "EF02"; # for grub MBR
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
