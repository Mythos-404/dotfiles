{config, ...}: {
  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
  ];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    modesetting.enable = true;
    powerManagement.enable = true;
  };

  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
