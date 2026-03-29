{pkgs, ...}: let
  inherit (pkgs.nix4vscode) forVscode;
in
  forVscode [
    # GitHub
    "github.copilot"
    "github.copilot-chat"
    "github.vscode-github-actions"
    "eamodio.gitlens"

    # Nix
    "arrterian.nix-env-selector"
    "jnoortheen.nix-ide"
    "mkhl.direnv"

    # Python / Jupyter
    "charliermarsh.ruff"
    "ms-python.debugpy"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-toolsai.vscode-jupyter-cell-tags"
    "ms-toolsai.vscode-jupyter-slideshow"
    "rodolphebarbanneau.python-docstring-highlighter"

    # 语言
    "golang.go"
    "haskell.haskell"
    "justusadam.language-haskell"
    "rust-lang.rust-analyzer"
    "ziglang.vscode-zig"
    "sumneko.lua"
    "tamasfe.even-better-toml"

    # 调试
    "vadimcn.vscode-lldb"

    # 构建系统
    "ms-vscode.cmake-tools"
    "ms-vscode.makefile-tools"
    "nefrob.vscode-just-syntax"

    # 容器
    "ms-azuretools.vscode-containers"
    "ms-azuretools.vscode-docker"

    # Web
    "biomejs.biome"
    "bradlc.vscode-tailwindcss"
    "ms-vscode.live-server"

    # 数据/文件格式与查看器
    "dotjoshjohnson.xml"
    "mechatroner.rainbow-csv"
    "misodee.vscode-nbt"
    "ms-vscode.hexeditor"
    "qwtel.sqlite-viewer"
    "redhat.vscode-yaml"

    # 编辑
    "christian-kohler.path-intellisense"
    "gruntfuggly.todo-tree"
    "humao.rest-client"
    "usernamehw.errorlens"
    "vscodevim.vim"
    "wakatime.vscode-wakatime"

    # 外观
    "manasxx.background-cover"
    "pkief.material-icon-theme"
    "rubenverg.bootstrap-product-icons"
    "t3dotgg.vsc-material-theme-but-i-wont-sue-you"

    # 其他
    "ms-ceintl.vscode-language-pack-zh-hans"
    "teamdman.super-factory-manager-language"
    "adpyke.codesnap"
  ]
