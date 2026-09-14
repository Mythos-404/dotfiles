{lib, ...}: let
  inherit (lib.generators) mkLuaInline;

  # Lua locals (rendered once at the top of hyprland.lua)
  mod = {_var = "SUPER";};
  terminal = {_var = "kitty -1";};

  # `mod .. " + <combo>"` (for binding with the main modifier)
  k = k: mkLuaInline "mod .. ${builtins.toJSON (" + " + k)}";
  # literal key name, e.g. `"Return"` or `"XF86AudioMute"`
  kl = key: mkLuaInline (builtins.toJSON key);
  # raw Lua dispatcher expression
  d = code: mkLuaInline code;
  # `hl.dsp.exec_cmd("<cmd>")`
  run = cmd: mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON cmd})";

  # hl.bind(keys, dispatcher)
  b = keys: disp: {_args = [keys disp];};
  # hl.bind(keys, dispatcher, opts)
  bo = keys: disp: opts: {_args = [keys disp opts];};

  locked = {locked = true;};
  lockedRepeat = {
    locked = true;
    repeating = true;
  };
  mouse = {mouse = true;};

  # 1..9 map to keys 1..9, 10 maps to key 0
  keyNum = n:
    toString (
      if n == 10
      then 0
      else n
    );
  wsName = n: toString n;
  mkSwitch = n: b (k (keyNum n)) (d "hl.dsp.focus({ workspace = ${builtins.toJSON (wsName n)} })");
  mkMoveFollow = n: b (k "SHIFT + ${keyNum n}") (d "hl.dsp.window.move({ workspace = ${builtins.toJSON (wsName n)} })");
  mkMoveSilent = n: b (k "CTRL + ${keyNum n}") (d "hl.dsp.window.move({ workspace = ${builtins.toJSON (wsName n)}, follow = false })");
  mkSwap = n: b (k "ALT + ${keyNum n}") (run "swap-workspace ${wsName n}");
in {
  inherit mod terminal;

  bind =
    # ── 应用启动 ──────────────────────────────────────
    [
      (b (k "Return") (d "hl.dsp.exec_cmd(terminal)"))
      (b (k "Space") (run "pkill rofi || rofi -show drun -modi drun,run,filebrowser"))
      (b (k "SHIFT + E") (run "thunar"))

      # ── 工具脚本 ──────────────────────────────────────
      (b (k "ALT + V") (run "clip-manager"))
      (b (k "ALT + S") (run "hyprshot -m region")) # 区域截图
      (b (k "SHIFT + S") (run "hyprshot -m region --freeze")) # 冻结截图
      (b (k "ALT + P") (run "hyprshot -m output")) # 全屏截图
      (b (k "SHIFT + W") (run "wallpaper-random"))
      (b (k "SHIFT + G") (run "gamemode-toggle"))
      (b (k "SHIFT + C") (run "sleep 0.5 && hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'"))

      # ── 窗口操作 ──────────────────────────────────────
      (b (k "SHIFT + Q") (d "hl.dsp.window.close()"))
      (b (k "M") (d ''hl.dsp.window.fullscreen({ mode = "maximized", action = "set" })''))
      (b (k "F") (d ''hl.dsp.window.fullscreen({ action = "unset" })''))
      (b (k "V") (d "hl.dsp.window.float()"))

      # ── 焦点移动 (HJKL) ──────────────────────────────
      (b (k "H") (d ''hl.dsp.focus({ direction = "l" })''))
      (b (k "L") (d ''hl.dsp.focus({ direction = "r" })''))
      (b (k "J") (d ''hl.dsp.focus({ direction = "d" })''))
      (b (k "K") (d ''hl.dsp.focus({ direction = "u" })''))

      # ── 移动窗口 ──────────────────────────────────────
      (b (k "CTRL + H") (d ''hl.dsp.window.move({ direction = "l" })''))
      (b (k "CTRL + L") (d ''hl.dsp.window.move({ direction = "r" })''))
      (b (k "CTRL + J") (d ''hl.dsp.window.move({ direction = "d" })''))
      (b (k "CTRL + K") (d ''hl.dsp.window.move({ direction = "u" })''))

      # ── 调整窗口大小 ──────────────────────────────────
      (b (k "SHIFT + H") (d "hl.dsp.window.resize({ x = -30, y = 0, relative = true })"))
      (b (k "SHIFT + L") (d "hl.dsp.window.resize({ x = 30, y = 0, relative = true })"))
      (b (k "SHIFT + J") (d "hl.dsp.window.resize({ x = 0, y = 30, relative = true })"))
      (b (k "SHIFT + K") (d "hl.dsp.window.resize({ x = 0, y = -30, relative = true })"))
    ]
    # ── 工作区切换 ────────────────────────────────────
    ++ map mkSwitch (lib.range 1 10)
    # ── 移动窗口到工作区 (跟随) ───────────────────────
    ++ map mkMoveFollow (lib.range 1 10)
    ++ [
      (b (k "SHIFT + bracketleft") (d ''hl.dsp.window.move({ workspace = "-1" })''))
      (b (k "SHIFT + bracketright") (d ''hl.dsp.window.move({ workspace = "+1" })''))
    ]
    # ── 移动窗口到工作区 (静默) ───────────────────────
    ++ map mkMoveSilent (lib.range 1 10)
    ++ [
      (b (k "CTRL + bracketleft") (d ''hl.dsp.window.move({ workspace = "-1", follow = false })''))
      (b (k "CTRL + bracketright") (d ''hl.dsp.window.move({ workspace = "+1", follow = false })''))
    ]
    # ── 工作区交换 ────────────────────────────────────
    ++ map mkSwap (lib.range 1 10)
    ++ [
      # ── 显示器切换 ────────────────────────────────────
      (b (k "Tab") (d ''hl.dsp.focus({ monitor = "+1" })''))
      (b (k "SHIFT + Tab") (d ''hl.dsp.focus({ monitor = "-1" })''))

      # ── 鼠标滚轮切换工作区 ────────────────────────────
      (b (k "mouse_down") (d ''hl.dsp.focus({ workspace = "e+1" })''))
      (b (k "mouse_up") (d ''hl.dsp.focus({ workspace = "e-1" })''))

      # ── Scratchpads (原生 special workspace) ──────────
      (b (k "W") (run "scratchpad-toggle term kitty-dropterm kitty -1 --class kitty-dropterm"))
      (b (k "E") (run "scratchpad-toggle yazi kitty-yazi kitty -1 --class kitty-yazi zsh -c yazi"))
      (b (k "ALT + B") (run "scratchpad-toggle btop kitty-btop kitty -1 --class kitty-btop btop"))

      # ── 多媒体键 ────────────────────────────────────────
      (bo (kl "XF86AudioRaiseVolume") (run "volume-ctl --inc") lockedRepeat)
      (bo (kl "XF86AudioLowerVolume") (run "volume-ctl --dec") lockedRepeat)
      (bo (kl "XF86MonBrightnessUp") (run "brightnessctl set +5%") lockedRepeat)
      (bo (kl "XF86MonBrightnessDown") (run "brightnessctl set 5%-") lockedRepeat)
      (bo (kl "XF86AudioMute") (run "volume-ctl --toggle") locked)
      (bo (kl "XF86AudioMicMute") (run "volume-ctl --toggle-mic") locked)
      (bo (kl "XF86Search") (run "volume-ctl --toggle-mic") locked)

      # ── 鼠标绑定 ────────────────────────────────────────
      (bo (k "mouse:272") (d "hl.dsp.window.drag()") mouse)
      (bo (k "mouse:273") (d "hl.dsp.window.resize()") mouse)
    ];
}
