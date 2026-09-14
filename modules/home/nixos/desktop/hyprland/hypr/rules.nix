{lib, ...}: {
  window_rule = [
    # ── Scratchpad 窗口规则 ─────────────────────────────
    # 下拉终端
    {
      match.class = "^(kitty-dropterm)$";
      float = true;
    }
    {
      match.class = "^(kitty-dropterm)$";
      workspace = "special:term silent";
    }
    {
      match.class = "^(kitty-dropterm)$";
      size = ["monitor_w * 0.75" "monitor_h * 0.60"];
    }
    {
      match.class = "^(kitty-dropterm)$";
      move = ["monitor_w * 0.125" "monitor_h * 0.05"];
    }
    {
      match.class = "^(kitty-dropterm)$";
      animation = "slideIn";
    }

    # yazi 文件管理器
    {
      match.class = "^(kitty-yazi)$";
      float = true;
    }
    {
      match.class = "^(kitty-yazi)$";
      workspace = "special:yazi silent";
    }
    {
      match.class = "^(kitty-yazi)$";
      size = ["monitor_w * 0.75" "monitor_h * 0.60"];
    }
    {
      match.class = "^(kitty-yazi)$";
      move = ["monitor_w * 0.125" "monitor_h * 0.05"];
    }

    # btop 系统监控
    {
      match.class = "^(kitty-btop)$";
      float = true;
    }
    {
      match.class = "^(kitty-btop)$";
      workspace = "special:btop silent";
    }
    {
      match.class = "^(kitty-btop)$";
      size = ["monitor_w * 0.75" "monitor_h * 0.60"];
    }
    {
      match.class = "^(kitty-btop)$";
      move = ["monitor_w * 0.125" "monitor_h * 0.05"];
    }

    # ── 通用浮动规则 ───────────────────────────────────
    {
      match.class = "^(pavucontrol|org.pulseaudio.pavucontrol)$";
      float = true;
    }
    {
      match.class = "^(pavucontrol|org.pulseaudio.pavucontrol)$";
      size = [800 600];
    }
    {
      match.class = "^(pavucontrol|org.pulseaudio.pavucontrol)$";
      center = true;
    }

    {
      match.class = "^([Rr]ofi)$";
      float = true;
    }
    {
      match.class = "^(xdg-desktop-portal-gtk)$";
      float = true;
    }
    {
      match.class = "^(org.gnome.Calculator)$";
      float = true;
    }
    {
      match.class = "^(nm-applet|nm-connection-editor|blueman-manager)$";
      float = true;
    }
    {
      match.class = "^(nwg-look|qt5ct|qt6ct)$";
      float = true;
    }
    {
      match.class = "^(file-roller|org.gnome.FileRoller)$";
      float = true;
    }
    {
      match.class = "^(gnome-system-monitor|org.gnome.SystemMonitor)$";
      float = true;
    }
    {
      match.class = "^(org.prismlauncher.PrismLauncher)$";
      float = true;
    }
    {
      match.class = "^(org.kde.polkit-kde-authentication-agent-1)$";
      float = true;
    }

    # Thunar 弹窗
    {
      match = {
        class = "^([Tt]hunar)$";
        title = "(File Operation Progress)";
      };
      float = true;
    }
    {
      match = {
        class = "^([Tt]hunar)$";
        title = "(Confirm to replace files)";
      };
      float = true;
    }

    # VSCode 弹窗
    {
      match = {
        class = "^(code|Code)$";
        title = "(Add Folder to Workspace)";
      };
      float = true;
    }

    # Steam (非主窗口浮动)
    {
      match = {
        class = "^([Ss]team)$";
        title = "^((?![Ss]team).*|[Ss]team [Ss]ettings)$";
      };
      float = true;
    }

    # 通用弹窗
    {
      match.title = "^(Open File)$";
      float = true;
    }
    {
      match.title = "^(Volume Control)$";
      float = true;
    }
    {
      match.title = "^(Picture-in-Picture)$";
      float = true;
    }
    {
      match.title = "^(Media viewer)$";
      float = true;
    }
    {
      match.title = "^(branchdialog)$";
      float = true;
    }

    # ── Picture-in-Picture ─────────────────────────────
    {
      match.title = "^(Picture-in-Picture)$";
      pin = true;
    }
    {
      match.title = "^(Picture-in-Picture)$";
      size = ["monitor_w * 0.25" "monitor_h * 0.25"];
    }
    {
      match.title = "^(Picture-in-Picture)$";
      move = ["monitor_w * 0.72" "monitor_h * 0.07"];
    }
    {
      match.title = "^(Picture-in-Picture)$";
      opacity = "0.95 0.75";
    }

    # ── 透明度 ─────────────────────────────────────────
    {
      match.class = "^([Ff]irefox|org.mozilla.firefox)$";
      opacity = "0.9 0.9";
    }
    {
      match.class = "^(kitty)$";
      opacity = "0.9 0.8";
    }
    {
      match.class = "^(code|Code)$";
      opacity = "0.9 0.8";
    }
    {
      match.class = "^([Tt]hunar)$";
      opacity = "0.9 0.8";
    }
    {
      match.class = "^(kitty-.*)$";
      opacity = "0.9 0.6";
    }
    {
      match.class = "^([Rr]ofi)$";
      opacity = "0.9 0.6";
    }
    {
      match.class = "^(neovide)$";
      opacity = "0.8 0.8";
    }

    # ── Tearing (游戏) ─────────────────────────────────
    {
      match.class = "^(cs2)$";
      immediate = true;
    }
    {
      match.class = "^(steam_app_.*)$";
      immediate = true;
    }
  ];
}
