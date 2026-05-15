{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      supportedFilesystems = [ "ext4" ]; # root partition

      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "rtsx_pci_sdmmc"
      ];
    };

    kernelModules = [ "kvm-intel" ];
  };
}
