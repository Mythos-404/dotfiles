{pkgs, ...}: let
  # ── 音量控制 ────────────────────────────────────────
  volume-ctl = pkgs.writeShellApplication {
    name = "volume-ctl";
    runtimeInputs = with pkgs; [pamixer libnotify];
    text = ''
      notify() {
        local vol
        vol=$(pamixer --get-volume)
        if [[ "$(pamixer --get-mute)" == "true" ]]; then
          notify-send -e -h string:x-canonical-private-synchronous:volume \
            -u low "Volume: Muted"
        else
          notify-send -e -h "int:value:$vol" \
            -h string:x-canonical-private-synchronous:volume \
            -u low "Volume: $vol%"
        fi
      }

      case "''${1:-}" in
        --inc)
          [[ "$(pamixer --get-mute)" == "true" ]] && pamixer -u
          pamixer -i "''${2:-5}" && notify ;;
        --dec)
          [[ "$(pamixer --get-mute)" == "true" ]] && pamixer -u
          pamixer -d "''${2:-5}" && notify ;;
        --toggle)      pamixer -t && notify ;;
        --toggle-mic)  pamixer --default-source -t
          if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
            notify-send -e -u low "Mic OFF"
          else
            notify-send -e -u low "Mic ON"
          fi ;;
        *) echo "Usage: volume-ctl [--inc|--dec|--toggle|--toggle-mic] [step]" ;;
      esac
    '';
  };

  # ── 剪贴板管理 ──────────────────────────────────────
  clip-manager = pkgs.writeShellApplication {
    name = "clip-manager";
    runtimeInputs = with pkgs; [cliphist rofi wl-clipboard];
    text = ''
      result=$(cliphist list | rofi -dmenu -config "$HOME/.config/rofi/config-clipboard.rasi" -p "Clipboard")
      if [[ -n "$result" ]]; then
        echo "$result" | cliphist decode | wl-copy
      fi
    '';
  };

  # ── 游戏模式切换 ────────────────────────────────────
  gamemode-toggle = pkgs.writeShellApplication {
    name = "gamemode-toggle";
    runtimeInputs = with pkgs; [hyprland jq libnotify];
    text = ''
      GAMEMODE=$(hyprctl -j getoption animations:enabled | jq -r '.bool // (.int == 1)')
      if [[ "$GAMEMODE" == "true" ]]; then
        hyprctl eval 'hl.config({
          animations = { enabled = false },
          decoration = { blur = { enabled = false }, rounding = 0 },
          general = { gaps_in = 0, gaps_out = 0, border_size = 1 }
        })
        hl.exec_scheduled_prop_refresh_immediately()'
        notify-send -e -u low "Game Mode ON"
      else
        hyprctl reload
        notify-send -e -u low "Game Mode OFF"
      fi
    '';
  };

  # ── 工作区交换 ──────────────────────────────────────
  swap-workspace = pkgs.writeShellApplication {
    name = "swap-workspace";
    runtimeInputs = with pkgs; [hyprland];
    text = ''
      hyprctl eval "
      local target_id = ''${1:-0}
      if target_id < 1 then return end
      local cur = hl.get_active_workspace()
      local target = hl.get_workspace(tostring(target_id))
      local cur_wins = hl.get_workspace_windows(cur)
      local target_wins = target and hl.get_workspace_windows(target) or {}
      for _, w in ipairs(target_wins) do
        hl.dispatch(hl.dsp.window.move({ workspace = tostring(cur.id), window = w, follow = false }))
      end
      for _, w in ipairs(cur_wins) do
        hl.dispatch(hl.dsp.window.move({ workspace = tostring(target_id), window = w, follow = false }))
      end
      "
    '';
  };

  # ── Scratchpad 启动/切换 ────────────────────────────
  # 用原生 special workspace 实现 pyprland scratchpad 效果
  # 按下快捷键时：如果窗口不存在则启动，存在则 toggle 显示/隐藏
  scratchpad-toggle = pkgs.writeShellApplication {
    name = "scratchpad-toggle";
    runtimeInputs = with pkgs; [hyprland jq];
    text = ''
      # Usage: scratchpad-toggle <name> <class> <command...>
      NAME="$1"; shift
      CLASS="$1"; shift
      CMD="$*"

      # 检查窗口是否已存在
      COUNT=$(hyprctl clients -j | jq -r --arg c "$CLASS" \
        '[.[] | select(.class == $c)] | length')

      if [[ "$COUNT" -eq 0 ]]; then
        # 窗口不存在，启动它
        hyprctl dispatch "hl.dsp.exec_cmd($(jq -Rn --arg c "$CMD" '$c'))"
      else
        # 窗口存在，toggle special workspace
        hyprctl dispatch "hl.dsp.workspace.toggle_special($(jq -Rn --arg n "$NAME" '$n'))"
      fi
    '';
  };
in {
  home.packages = [
    volume-ctl
    clip-manager
    gamemode-toggle
    swap-workspace
    scratchpad-toggle
  ];
}
