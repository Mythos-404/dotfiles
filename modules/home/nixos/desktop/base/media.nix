{pkgs, ...}: {
  home.packages = with pkgs; [
    # audio control
    pwvucontrol
    playerctl
    pulsemixer

    # video/audio tools
    vulkan-tools
    mesa-demos
    nvitop
  ];
}
