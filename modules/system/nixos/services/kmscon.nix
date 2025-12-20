{pkgs, ...}: {
  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = true;
    fonts = with pkgs; [
      {
        name = "Maple Mono NF CN";
        package = maple-mono.NF-CN-unhinted;
      }
      {
        name = "Iosevka Term";
        package = nerd-fonts.iosevka-term;
      }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=17";
    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
}
