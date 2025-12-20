{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    psmisc # killall/pstree/prtstat/fuser/...
    pciutils # lspci
    usbutils # lsusb
  ];
}
