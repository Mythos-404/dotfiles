{
  config,
  pkgs,
  lib,
  ...
}: let
  localBin = "${config.home.homeDirectory}/.local/bin";
  goBin = "${config.home.homeDirectory}/.go/bin";
  rustBin = "${config.home.homeDirectory}/.cargo/bin";

  shellAliases = {
    cat = "bat -p";
    ps = "procs";

    lzg = "lazygit";
    N = "nvim";
  };
in {
  # NOTE: only works in bash/zsh
  home.shellAliases = shellAliases;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:${localBin}:${goBin}:${rustBin}"
    '';
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    plugins = with pkgs; [
      {
        name = "powerlevel10k";
        src = zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      zshConfig = lib.mkOrder 1000 ''
        source ~/.p10k.zsh

        export PATH="$PATH:${localBin}:${goBin}:${rustBin}"
      '';
    in
      lib.mkMerge [zshConfigEarlyInit zshConfig];
  };

  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
