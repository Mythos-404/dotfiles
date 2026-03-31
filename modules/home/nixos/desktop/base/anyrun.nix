{
  inputs,
  pkgs,
  ...
}: let
  anyrunPkgs = inputs.anyrun.packages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        anyrunPkgs.applications
        anyrunPkgs.rink # 计算器
        anyrunPkgs.shell # shell 命令
        anyrunPkgs.symbols # Unicode 符号
        anyrunPkgs.translate # 翻译
      ];

      width = {fraction = 0.3;};
      y = {fraction = 0.3;};
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = ''
      * {
        all: unset;
        font-family: "Maple Mono NF CN", "Noto Sans CJK SC", sans-serif;
        font-size: 14px;
      }

      #window {
        background: transparent;
      }

      box#main {
        background: rgba(30, 30, 46, 0.85);
        border: 2px solid rgba(137, 180, 250, 0.6);
        border-radius: 16px;
        padding: 8px;
      }

      entry#entry {
        background: rgba(49, 50, 68, 0.8);
        border: 1px solid rgba(137, 180, 250, 0.3);
        border-radius: 12px;
        padding: 8px 16px;
        margin: 8px;
        color: #cdd6f4;
        caret-color: #89b4fa;
        min-height: 32px;
      }

      entry#entry:focus {
        border-color: rgba(137, 180, 250, 0.8);
      }

      list#main {
        margin: 4px 8px;
      }

      row#plugin {
        padding: 4px 0;
      }

      row#match {
        padding: 4px 12px;
        border-radius: 8px;
      }

      row#match:selected, row#match:hover {
        background: rgba(137, 180, 250, 0.15);
      }

      label#match-title {
        color: #cdd6f4;
        font-size: 14px;
      }

      label#match-desc {
        color: #a6adc8;
        font-size: 12px;
      }
    '';

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 8,
          terminal: Some("kitty"),
        )
      '';
    };
  };
}
