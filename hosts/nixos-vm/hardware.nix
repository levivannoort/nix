{ lib, ... }:

{
  # aarch64 guest on an Apple Silicon host. The previous config declared
  # x86_64-linux in the flake while asking nixosSystem for aarch64-linux, and
  # loaded `kvm-intel`/`kvm-amd` — both x86-only, and both nested-virt modules
  # that a guest has no use for regardless.
  nixpkgs.hostPlatform = "aarch64-linux";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "virtio_net"
    "usbhid"
    "sr_mod"
  ];

  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Label-based so this survives a reinstall. Create them at install time with:
  #   mkfs.ext4 -L nixos /dev/vda2 && mkfs.fat -F32 -n boot /dev/vda1
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
}
