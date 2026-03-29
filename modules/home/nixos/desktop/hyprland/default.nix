{lib, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = import ./hypr {inherit lib;};
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}
