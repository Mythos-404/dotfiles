{pkgs, ...}: let
  # ══════════════════════════════════════════════════════════════
  # 方式1: pkgs.writeShellApplication
  #
  # 这是 Nix 里写 shell 脚本的最佳方式
  # runtimeInputs 里的包会自动加入脚本的 PATH
  # 所以脚本里直接写 `swww img` 就行，不用写绝对路径
  # Nix 构建时还会自动跑 shellcheck 帮你检查语法
  # ══════════════════════════════════════════════════════════════
  wallpaper-random = pkgs.writeShellApplication {
    name = "wallpaper-random";
    runtimeInputs = with pkgs; [swww findutils coreutils wallust coreutils-full];
    text = ''
      WALLPAPER_DIR="''${1:-''${XDG_PICTURES_DIR:-$HOME/pic}/wallpapers}"

      if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "壁纸目录不存在: $WALLPAPER_DIR" >&2
        exit 1
      fi

      # 找出所有图片，随机选一张
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \
        \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.gif' -o -name '*.webp' \) \
        | shuf -n 1)

      if [ -z "$WALLPAPER" ]; then
        echo "目录中没有找到图片: $WALLPAPER_DIR" >&2
        exit 1
      fi

      echo "设置壁纸: $WALLPAPER"
      swww img "$WALLPAPER" \
        --transition-type grow \
        --transition-duration 1.5 \
        --transition-fps 60

      # 为 rofi 创建当前壁纸链接
      ln -sf "$WALLPAPER" "$HOME/.config/rofi/.current_wallpaper"

      # wallust 动态配色 (跳过 tty 和终端变更)
      wallust run -s "$WALLPAPER" &
    '';
  };
in {
  home.packages = [
    pkgs.swww
    pkgs.wallust
    wallpaper-random
  ];

  systemd.user.services.swww = {
    Unit = {
      Description = "swww wallpaper daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
