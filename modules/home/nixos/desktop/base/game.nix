{pkgs, ...}: {
  home.packages = with pkgs; [
    # https://github.com/flightlessmango/MangoHud
    # a simple overlay program for monitoring FPS, temperature, CPU and GPU load, and more.
    mangohud

    (prismlauncher.override {
      jdks = [
        zulu21
        zulu
      ];
    })
  ];
}
