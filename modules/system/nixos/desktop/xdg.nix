{
  lib,
  pkgs,
  ...
}: {
  xdg.terminal-exec = {
    enable = true;
    package = pkgs.xdg-terminal-exec-mkhl;
    settings = let
      my_terminal_desktop = [
        # NOTE: We have add these packages at user level
        "kitty.desktop"
      ];
    in {
      hyprland = my_terminal_desktop;
      niri = my_terminal_desktop;
      default = my_terminal_desktop;
    };
  };

  xdg = {
    autostart.enable = lib.mkDefault true;
    menus.enable = lib.mkDefault true;
    mime.enable = lib.mkDefault true;
    icons.enable = lib.mkDefault true;
  };

  xdg.portal = {
    enable = true;

    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
      };
    };

    # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
    # This will make xdg-open use the portal to open programs,
    # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
    # xdg-open is used by almost all programs to open a unknown file/uri
    # alacritty as an example, it use xdg-open as default, but you can also custom this behavior
    # and vscode has open like `External Uri Openers`
    xdgOpenUsePortal = true;

    # ls /run/current-system/sw/share/xdg-desktop-portal/portals/
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # provides file picker / OpenURI
      xdg-desktop-portal-hyprland # for Hyprland screensharing & window/output chooser
      xdg-desktop-portal-gnome # for GNOME/Niri screensharing
    ];
  };
}
