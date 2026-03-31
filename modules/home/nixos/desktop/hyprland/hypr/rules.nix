{
  # 新语法: windowrule = <rule> <value>, match:<field> <pattern>

  # ── Scratchpad 窗口规则 ─────────────────────────────
  windowrule = [
    # 下拉终端
    "float on, match:class ^(kitty-dropterm)$"
    "workspace special:term silent, match:class ^(kitty-dropterm)$"
    "size 75% 60%, match:class ^(kitty-dropterm)$"
    "move 12.5% 5%, match:class ^(kitty-dropterm)$"
    "animation slideIn, match:class ^(kitty-dropterm)$"

    # yazi 文件管理器
    "float on, match:class ^(kitty-yazi)$"
    "workspace special:yazi silent, match:class ^(kitty-yazi)$"
    "size 75% 60%, match:class ^(kitty-yazi)$"
    "move 12.5% 5%, match:class ^(kitty-yazi)$"

    # btop 系统监控
    "float on, match:class ^(kitty-btop)$"
    "workspace special:btop silent, match:class ^(kitty-btop)$"
    "size 75% 60%, match:class ^(kitty-btop)$"
    "move 12.5% 5%, match:class ^(kitty-btop)$"

    # ── 通用浮动规则 ───────────────────────────────────
    "float on, match:class ^(pavucontrol|org.pulseaudio.pavucontrol)$"
    "size 800 600, match:class ^(pavucontrol|org.pulseaudio.pavucontrol)$"
    "center on, match:class ^(pavucontrol|org.pulseaudio.pavucontrol)$"

    "float on, match:class ^([Rr]ofi)$"
    "float on, match:class ^(xdg-desktop-portal-gtk)$"
    "float on, match:class ^(org.gnome.Calculator)$"
    "float on, match:class ^(nm-applet|nm-connection-editor|blueman-manager)$"
    "float on, match:class ^(nwg-look|qt5ct|qt6ct)$"
    "float on, match:class ^(file-roller|org.gnome.FileRoller)$"
    "float on, match:class ^(gnome-system-monitor|org.gnome.SystemMonitor)$"
    "float on, match:class ^(org.prismlauncher.PrismLauncher)$"
    "float on, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"

    # Thunar 弹窗
    "float on, match:class ^([Tt]hunar)$, match:title (File Operation Progress)"
    "float on, match:class ^([Tt]hunar)$, match:title (Confirm to replace files)"

    # VSCode 弹窗
    "float on, match:class ^(code|Code)$, match:title (Add Folder to Workspace)"

    # Steam (非主窗口浮动)
    ''float on, match:class ^([Ss]team)$, match:title ^((?![Ss]team).*|[Ss]team [Ss]ettings)$''

    # 通用弹窗
    "float on, match:title ^(Open File)$"
    "float on, match:title ^(Volume Control)$"
    "float on, match:title ^(Picture-in-Picture)$"
    "float on, match:title ^(Media viewer)$"
    "float on, match:title ^(branchdialog)$"

    # ── Picture-in-Picture ─────────────────────────────
    "pin on, match:title ^(Picture-in-Picture)$"
    "size 25% 25%, match:title ^(Picture-in-Picture)$"
    "move 72% 7%, match:title ^(Picture-in-Picture)$"
    "opacity 0.95 0.75, match:title ^(Picture-in-Picture)$"

    # ── 透明度 ─────────────────────────────────────────
    "opacity 0.9 0.9, match:class ^([Ff]irefox|org.mozilla.firefox)$"
    "opacity 0.9 0.8, match:class ^(kitty)$"
    "opacity 0.9 0.8, match:class ^(code|Code)$"
    "opacity 0.9 0.8, match:class ^([Tt]hunar)$"
    "opacity 0.9 0.6, match:class ^(kitty-.*)$"
    "opacity 0.9 0.6, match:class ^([Rr]ofi)$"
    "opacity 0.8 0.8, match:class ^(neovide)$"

    # ── Tearing (游戏) ─────────────────────────────────
    "immediate on, match:class ^(cs2)$"
    "immediate on, match:class ^(steam_app_.*)$"
  ];
}
