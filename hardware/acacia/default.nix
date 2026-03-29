{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      theme = pkgs.grub-theme-angle;
      extraEntries = ''
        menuentry "Windows" {
          search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
          chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;
  networking.networkmanager.enable = true;
}
