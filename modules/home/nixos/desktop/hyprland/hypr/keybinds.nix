{
  "$mainMod" = "Super";
  "$TERMINAL" = "kitty -1";

  # ── 应用启动 ──────────────────────────────────────
  bind = [
    "$mainMod, Return, exec, $TERMINAL"
    "$mainMod, Space, exec, pkill rofi || rofi -show drun -modi drun,run,filebrowser"
    "$mainMod+Shift, E, exec, thunar"

    # ── 工具脚本 ──────────────────────────────────────
    "$mainMod+Alt, V, exec, clip-manager"
    "$mainMod+Alt, S, exec, hyprshot -m region" # 区域截图
    "$mainMod+Shift, S, exec, hyprshot -m region --freeze" # 冻结截图
    "$mainMod+Alt, P, exec, hyprshot -m output" # 全屏截图
    "$mainMod+Shift, W, exec, wallpaper-random"
    "$mainMod+Shift, G, exec, gamemode-toggle"
    "$mainMod+Shift, C, exec, sleep 0.5 && hyprctl dispatch dpms off"

    # ── 窗口操作 ──────────────────────────────────────
    "$mainMod+Shift, Q, killactive,"
    "$mainMod, M, fullscreen, 1"
    "$mainMod, F, fullscreen, 0"
    "$mainMod, V, togglefloating,"

    # ── 焦点移动 (HJKL) ──────────────────────────────
    "$mainMod, H, movefocus, l"
    "$mainMod, L, movefocus, r"
    "$mainMod, J, movefocus, d"
    "$mainMod, K, movefocus, u"

    # ── 移动窗口 ──────────────────────────────────────
    "$mainMod+Ctrl, H, movewindow, l"
    "$mainMod+Ctrl, L, movewindow, r"
    "$mainMod+Ctrl, J, movewindow, d"
    "$mainMod+Ctrl, K, movewindow, u"

    # ── 调整窗口大小 ──────────────────────────────────
    "$mainMod+Shift, H, resizeactive, -30 0"
    "$mainMod+Shift, L, resizeactive, 30 0"
    "$mainMod+Shift, J, resizeactive, 0 30"
    "$mainMod+Shift, K, resizeactive, 0 -30"

    # ── 工作区切换 ────────────────────────────────────
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"

    # ── 移动窗口到工作区 (跟随) ───────────────────────
    "$mainMod+Shift, 1, movetoworkspace, 1"
    "$mainMod+Shift, 2, movetoworkspace, 2"
    "$mainMod+Shift, 3, movetoworkspace, 3"
    "$mainMod+Shift, 4, movetoworkspace, 4"
    "$mainMod+Shift, 5, movetoworkspace, 5"
    "$mainMod+Shift, 6, movetoworkspace, 6"
    "$mainMod+Shift, 7, movetoworkspace, 7"
    "$mainMod+Shift, 8, movetoworkspace, 8"
    "$mainMod+Shift, 9, movetoworkspace, 9"
    "$mainMod+Shift, 0, movetoworkspace, 10"
    "$mainMod+Shift, bracketleft, movetoworkspace, -1"
    "$mainMod+Shift, bracketright, movetoworkspace, +1"

    # ── 移动窗口到工作区 (静默) ───────────────────────
    "$mainMod+Ctrl, 1, movetoworkspacesilent, 1"
    "$mainMod+Ctrl, 2, movetoworkspacesilent, 2"
    "$mainMod+Ctrl, 3, movetoworkspacesilent, 3"
    "$mainMod+Ctrl, 4, movetoworkspacesilent, 4"
    "$mainMod+Ctrl, 5, movetoworkspacesilent, 5"
    "$mainMod+Ctrl, 6, movetoworkspacesilent, 6"
    "$mainMod+Ctrl, 7, movetoworkspacesilent, 7"
    "$mainMod+Ctrl, 8, movetoworkspacesilent, 8"
    "$mainMod+Ctrl, 9, movetoworkspacesilent, 9"
    "$mainMod+Ctrl, 0, movetoworkspacesilent, 10"
    "$mainMod+Ctrl, bracketleft, movetoworkspacesilent, -1"
    "$mainMod+Ctrl, bracketright, movetoworkspacesilent, +1"

    # ── 工作区交换 ────────────────────────────────────
    "$mainMod+Alt, 1, exec, swap-workspace 1"
    "$mainMod+Alt, 2, exec, swap-workspace 2"
    "$mainMod+Alt, 3, exec, swap-workspace 3"
    "$mainMod+Alt, 4, exec, swap-workspace 4"
    "$mainMod+Alt, 5, exec, swap-workspace 5"
    "$mainMod+Alt, 6, exec, swap-workspace 6"
    "$mainMod+Alt, 7, exec, swap-workspace 7"
    "$mainMod+Alt, 8, exec, swap-workspace 8"
    "$mainMod+Alt, 9, exec, swap-workspace 9"
    "$mainMod+Alt, 0, exec, swap-workspace 10"

    # ── 显示器切换 ────────────────────────────────────
    "$mainMod, Tab, focusmonitor, +1"
    "$mainMod+Shift, Tab, focusmonitor, -1"

    # ── 鼠标滚轮切换工作区 ────────────────────────────
    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"

    # ── Scratchpads (原生 special workspace) ──────────
    "$mainMod, W, exec, scratchpad-toggle term kitty-dropterm kitty -1 --class kitty-dropterm"
    "$mainMod, E, exec, scratchpad-toggle yazi kitty-yazi kitty -1 --class kitty-yazi zsh -c yazi"
    "$mainMod+Alt, B, exec, scratchpad-toggle btop kitty-btop kitty -1 --class kitty-btop btop"
  ];

  # ── 多媒体键 ────────────────────────────────────────
  bindel = [
    ", XF86AudioRaiseVolume, exec, volume-ctl --inc"
    ", XF86AudioLowerVolume, exec, volume-ctl --dec"
    ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
    ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
  ];

  bindl = [
    ", XF86AudioMute, exec, volume-ctl --toggle"
    ", XF86AudioMicMute, exec, volume-ctl --toggle-mic"
    ", XF86Search, exec, volume-ctl --toggle-mic"
  ];

  # ── 鼠标绑定 ────────────────────────────────────────
  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];
}
