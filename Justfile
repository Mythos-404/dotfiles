set shell := ["bash", "-c"]

default:
    @just --list

systems := if os() == "linux" { `nix eval .#nixosConfigurations --apply 'x: builtins.concatStringsSep "\n" (builtins.attrNames x)' --raw 2> /dev/null || true` } else if os() == "darwin" { `nix eval .#darwinConfigurations --apply 'x: builtins.concatStringsSep "\n" (builtins.attrNames x)' --raw 2> /dev/null || true` } else { "" }
deploys := `find deploys -name '*.nix' -exec basename {} .nix \; 2> /dev/null || true`

############################################################################
#
#  系统管理命令
#
############################################################################

alias l := local
alias ls := list
alias u := use
alias b := boot
alias t := test
alias rb := rollback

# 列出该系统可用的系统配置
[group("system")]
list:
    #!/usr/bin/env bash
    echo "可用的系统配置:"
    for system in "{{ systems }}"; do
        echo " - ${system}";
    done

# 构建并切换到指定的系统配置
[group("system")]
[linux]
use system *flargs="": (_check-system system)
    @sudo nixos-rebuild switch --flake .#{{ system }} {{ flargs }}

# 构建并切换到指定的系统配置
[group("system")]
[macos]
use system:
    @sudo darwin-rebuild switch --flake .#{{ system }} {{ flargs }}

# 构建系统但不切换 (下次启动生效)
[group("system")]
[linux]
boot system *flargs="": (_check-system system)
    @sudo nixos-rebuild boot --flake .#{{ system }} {{ flargs }}

# 测试系统配置 (临时切换，重启后恢复)
[group("system")]
[linux]
test system *flargs="": (_check-system system)
    @sudo nixos-rebuild test --flake .#{{ system }} {{ flargs }}

# 根据当前主机名自动部署
[group("system")]
local mode="switch": _check-hostname
    #!/usr/bin/env bash
    hostname=$(hostname -s)
    echo "🔧 检测到主机名: ${hostname}"

    if [[ "{{ os() }}" == "linux" ]]; then
        echo "🐧 使用 nixos-rebuild {{ mode }}"
        sudo nixos-rebuild {{ mode }} --flake .#${hostname} --show-trace
    elif [[ "{{ os() }}" == "darwin" ]]; then
        echo "🍎 使用 darwin-rebuild {{ mode }}"
        sudo darwin-rebuild {{ mode }} --flake .#${hostname}
    fi

# 回滚到上一个配置
[group("system")]
[linux]
rollback:
    @sudo nixos-rebuild switch --rollback

# 回滚到上一个配置
[group("system")]
[macos]
rollback:
    @sudo darwin-rebuild rollback

############################################################################
#
#  Nix 管理命令
#
############################################################################

alias h := history
alias c := clean
alias gf := gc-full
alias up := update
alias r := repl
alias ch := check
alias i := info
alias gr := gcroots
alias v := verify
alias rp := repair

# 列出系统所有配置文件的历史记录
[group("nix")]
history:
    @nix profile history --profile /nix/var/nix/profiles/system

# 删除超过 7 天的 Nix 配置文件历史记录
[group("nix")]
clean:
    @echo "🧹 清理历史配置..."
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
    @# 清理 home-manager 历史
    @if [ -d "${XDG_STATE_HOME}/nix/profiles/home-manager" ]; then \
        sudo nix profile wipe-history --profile "${XDG_STATE_HOME}/nix/profiles/home-manager" --older-than 7d 2>/dev/null || true; \
    elif [ -d "${HOME}/.local/state/nix/profiles/home-manager" ]; then \
        sudo nix profile wipe-history --profile "${HOME}/.local/state/nix/profiles/home-manager" --older-than 7d 2>/dev/null || true; \
    else \
        true; \
    fi

# 垃圾收集 7 天前未使用的 nix 存储条目
[confirm("确认清理 7 天前的旧版本? yes/[no]: ")]
[group("nix")]
gc:
    @echo "🗑️  开始垃圾回收..."
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d
    @echo "✅ 垃圾回收完成"

# 先清理历史再垃圾回收（推荐）
[confirm("确认执行完整清理 (清理历史 + 垃圾回收)? yes/[no]: ")]
[group("nix")]
gc-full: clean gc
    @echo "✅ 完整清理完成"

# 更新 flake 输入
[group("nix")]
update input="":
    nix flake update {{ input }}
    @git add flake.lock
    @git commit -m "chore: update flake lock file" > /dev/null || echo "⚠️ 无更改需要提交"

# 格式化代码
[group("nix")]
fmt:
    @echo "✨ 格式化代码..."
    @nix fmt

# 用 flake 打开 nix repl
[group("nix")]
repl:
    nix repl -f flake:nixpkgs

# 运行 flake 检查
[group("nix")]
check:
    @echo "🔍 检查 flake..."
    nix flake check --show-trace

# 显示 flake 信息
[group("nix")]
info:
    @nix flake metadata

# 显示所有自动 GC roots
[group("nix")]
gcroots:
    @ls -al /nix/var/nix/gcroots/auto/

# 验证 nix store 完整性
[group("nix")]
verify:
    @echo "🔍 验证 Nix Store..."
    nix store verify --all

# 修复 nix store 条目
[group("nix")]
repair *paths:
    @echo "🔧 修复 Nix Store 条目..."
    nix store repair {{ paths }}

############################################################################
#
#  部署管理命令
#
############################################################################

alias dls := deploy-list
alias d := deploy

# 列出可用的部署配置
[group("deploy")]
deploy-list:
    #!/usr/bin/env bash
    echo "可用的部署配置:"
    for deploy in "{{ deploys }}"; do
        if [ -f "deploys/${deploy}.nix" ]; then
            echo "  ${deploy} - $(grep 'hostname.*=' deploy/${deploy}.nix | cut -d '"' -f2)"
        fi
    done

# 部署到指定目标
[group("deploy")]
deploy target: (_check-deploy target)
    @echo "部署到目标: {{ target }}"
    nix run github:serokell/deploy-rs -- . #{{ target }}

############################################################################
#
#  开发辅助命令
#
############################################################################

# 进入开发 shell (包含所有必要工具)
[group("dev")]
shell:
    @echo "🐚 进入开发环境..."
    nix shell nixpkgs#git nixpkgs#neovim nixpkgs#just nixpkgs#treefmt nixpkgs#alejandra nixpkgs#bash --command bash

# 查看系统 PATH
[group("dev")]
path:
    @echo ${PATH} | tr ':' '\n'

# 显示环境变量
[group("dev")]
env:
    @env | sort

# 显示 flake 依赖树
[group("dev")]
tree:
    nix flake show

############################################################################
#
#  Git 辅助命令
#
############################################################################

alias ggc := git-gc

# 清理 git reflog 和不可达对象
[group("git")]
git-gc:
    git reflog expire --expire-unreachable=now --all
    git gc --prune=now

############################################################################
#
#  内部辅助函数
#
############################################################################

# 检查系统配置是否存在
[linux]
[private]
_check-system system:
    #!/usr/bin/env bash
    if ! nix eval .#nixosConfigurations --apply 'x: builtins.hasAttr "{{ system }}" x' 2>/dev/null | grep -q true; then
        echo "❌ 错误: 无法找到系统配置 '{{ system }}'."
        just ls
        exit 1
    fi

# 检查系统配置是否存在
[macos]
[private]
_check-system system:
    #!/usr/bin/env bash
    if ! nix eval .#darwinConfigurations --apply 'x: builtins.hasAttr "{{ system }}" x' 2>/dev/null | grep -q true; then
        echo "❌ 错误: 无法找到系统配置 '{{ system }}'."
        just ls
        exit 1
    fi

# 检查部署配置是否存在
[private]
_check-deploy target:
    #!/usr/bin/env bash
    if [ !  -f "deploys/{{ target }}.nix" ]; then
        echo "❌ 错误: 部署配置 deploys/{{ target }}.nix 不存在"
        echo ""
        echo "可用的部署目标:"
        for deploy in "{{ deploys }}"; do
            echo "  ${deploy}"
        done
        exit 1
    fi

# 检查主机名是否存在对应配置
[private]
_check-hostname:
    #!/usr/bin/env bash
    hostname=$(hostname -s)
    has_config=false

    for system in "{{ systems }}"; do
        if [ "${system}" = "${hostname}" ]; then
            has_config=true
            break
        fi
    done

    if [ "${has_config}" = false ]; then
        echo "❌ 错误:  未找到主机名 '${hostname}' 对应的配置"
        echo ""
        echo "可用的系统配置:"
        for system in "{{ systems }}"; do
            echo "  - ${system}"
        done
        exit 1
    fi
