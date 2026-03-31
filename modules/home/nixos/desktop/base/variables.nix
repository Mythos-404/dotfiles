{
  home.sessionVariables = {
    # 默认文件管理器 (yazi 通过 kitty 启动)
    FILE_MANAGER = "kitty -1 -e yazi";

    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1"; # for firefox to run on wayland
    MOZ_WEBRENDER = "1";
    # enable native Wayland support for most Electron apps
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    # misc
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
