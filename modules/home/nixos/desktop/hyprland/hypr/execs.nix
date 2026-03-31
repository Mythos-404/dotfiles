{
  exec-once = [
    "fcitx5 -d -r"

    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"

    "sleep 0.5 && wallpaper-random"
  ];
}
