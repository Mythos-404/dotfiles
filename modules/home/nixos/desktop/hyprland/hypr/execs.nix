{lib, ...}: let
  inherit (lib.generators) mkLuaInline;

  cmds = [
    "fcitx5 -d -r"

    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"

    "sleep 0.5 && wallpaper-random"
  ];
in {
  # `exec-once` 在 Lua 下的等价写法:在 hyprland.start 事件里执行
  on = {
    _args = [
      "hyprland.start"
      (mkLuaInline ''
        function()
        ${lib.concatMapStrings (c: "  hl.exec_cmd(${builtins.toJSON c})\n") cmds}end
      '')
    ];
  };
}
