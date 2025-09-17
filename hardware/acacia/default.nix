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
      theme = "/boot/grub/themes/Angle";
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

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    kitty
    git
    vscode.fhs
    firefox
    alejandra
    nil
    direnv
    perl
    gnumake
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
