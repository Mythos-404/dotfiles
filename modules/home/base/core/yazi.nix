{pkgs, ...}: let
  yaziPlugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "4e55902";
  };
in {
  programs.yazi = {
    enable = true;
    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "Y";

    # https://github.com/sxyazi/yazi/blob/c9327ca85180afddf365d4bbcab329ae9a10ff96/nix/yazi.nix#L7
    # 因为yazi仓库的flake包没有extraPackages所以采取其他办法

    # extraPackages = with pkgs; [
    #   ripdrag
    #   util-linux
    #   duckdb
    #   hexyl
    # ];

    package = pkgs.yazi.override {
      _7zz = pkgs._7zz-rar;
      runtimeDeps = ps:
        with pkgs;
          [
            ripdrag
            util-linux
            duckdb
            hexyl
          ]
          ++ ps;
    };

    settings = {
      mgr = {
        sort_by = "natural";
        sort_sensitive = true;
        sort_dir_first = true;
        show_symlink = true;
        mouse_events = ["click" "scroll" "touch" "drag"];
      };
      preview = {
        max_width = 2160;
        max_height = 3840;
        image_filter = "lanczos3";
        image_quality = 90;
      };
      opener = {
        edit = [
          {
            run = ''''${EDITOR:=nvim} "$@"'';
            desc = "$EDITOR";
            block = true;
            for = "unix";
          }
        ];
      };

      prepend_previewers = [
        {
          url = "*.csv";
          run = "duckdb";
        }
        {
          url = "*.tsv";
          run = "duckdb";
        }
        {
          url = "*.json";
          run = "duckdb";
        }
        {
          url = "*.parquet";
          run = "duckdb";
        }
        {
          url = "*.xlsx";
          run = "duckdb";
        }
        {
          url = "*.db";
          run = "duckdb";
        }
        {
          url = "*.duckdb";
          run = "duckdb";
        }
        {
          url = "*";
          run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
        }
      ];

      prepend_preloaders = [
        {
          url = "*.csv";
          run = "duckdb";
          multi = false;
        }
        {
          url = "*.tsv";
          run = "duckdb";
          multi = false;
        }
        {
          url = "*.json";
          run = "duckdb";
          multi = false;
        }
        {
          url = "*.parquet";
          run = "duckdb";
          multi = false;
        }
        {
          url = "*.xlsx";
          run = "duckdb";
          multi = false;
        }
      ];
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "k";
          run = "arrow -1";
          desc = "Previous file";
        }
        {
          on = "j";
          run = "arrow 1";
          desc = "Next file";
        }
        {
          on = "z";
          run = "plugin zoxide";
          desc = "Jump to a directory via zoxide";
        }
        {
          on = "Z";
          run = "plugin fzf";
          desc = "Jump to a file/directory via fzf";
        }
        {
          on = ["g" "t"];
          run = "cd /tmp";
          desc = "Go to the temp directory";
        }
        {
          on = ["g" "r"];
          run = "cd /run/user";
          desc = "Go to the user run directory";
        }
        {
          on = ["g" "."];
          run = ["cd ~/.dotfiles" "hidden toggle"];
          desc = "Go to the dotfiles directory";
        }

        # Plugins Keymap
        # Toggle pane
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }

        # Chmod plugin
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }

        # Mount plugin
        {
          on = ["M"];
          run = "plugin mount";
          desc = "Open mount menu";
        }

        # Jump to char plugin
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to a character in the filename";
        }

        # Diff plugin
        {
          on = ["<C-d>"];
          run = "plugin diff";
          desc = "Diff the selected with the hovered file";
        }

        # Duckdb plugin
        {
          on = "H";
          run = "plugin duckdb -1";
          desc = "Scroll one column to the left";
        }
        {
          on = "L";
          run = "plugin duckdb +1";
          desc = "Scroll one column to the right";
        }
        {
          on = ["b" "o"];
          run = "plugin duckdb -open";
          desc = "open with duckdb";
        }
        {
          on = ["b" "u"];
          run = "plugin duckdb -ui";
          desc = "open with duckdb ui";
        }
      ];
    };

    plugins = {
      git = "${yaziPlugins}/git.yazi";
      diff = "${yaziPlugins}/diff.yazi";
      mount = "${yaziPlugins}/mount.yazi";
      chmod = "${yaziPlugins}/chmod.yazi";
      piper = "${yaziPlugins}/piper.yazi";
      smart-enter = "${yaziPlugins}/smart-enter.yazi";
      full-border = "${yaziPlugins}/full-border.yazi";
      toggle-pane = "${yaziPlugins}/toggle-pane.yazi";
      jump-to-char = "${yaziPlugins}/jump-to-char.yazi";

      duckdb = pkgs.fetchFromGitHub {
        owner = "wylie102";
        repo = "duckdb.yazi";
        rev = "3f8c863";
      };
    };

    initLua = ''
      require("git"):setup()
      require("full-border"):setup()

      require("duckdb"):setup()
    '';
  };
}
