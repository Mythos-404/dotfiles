{
  config,
  lib,
  ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  # GitHub CLI tool
  # https://cli.github.com/manual/
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      init.defaultBranch = "main";
      trim.bases = "develop,master,main"; # for git-trim
      push.autoSetupRemote = true;
      pull.rebase = true;
      log.date = "iso"; # use iso format for date

      aliases = {
        # common aliases
        br = "branch";
        co = "checkout";
        st = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        cm = "commit -m"; # commit via `git cm <message>`
        ca = "commit -am"; # commit all changes via `git ca <message>`
        dc = "diff --cached";

        amend = "commit --amend -m"; # amend commit message via `git amend <message>`
        unstage = "reset HEAD --"; # unstage file via `git unstage <file>`
        merged = "branch --merged"; # list merged(into HEAD) branches via `git merged`
        unmerged = "branch --no-merged"; # list unmerged(into HEAD) branches via `git unmerged`
        nonexist = "remote prune origin --dry-run"; # list non-exist(remote) branches via `git nonexist`

        # delete merged branches except master & dev & staging
        #  `!` indicates it's a shell script, not a git subcommand
        delmerged = ''! git branch --merged | egrep -v "(^\*|main|master|dev|staging)" | xargs git branch -d'';
        # delete non-exist(remote) branches
        delnonexist = "remote prune origin";

        # aliases for submodule
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
    };
  };

  # A syntax-highlighting pager for git, diff, grep, and blame output
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      diff-so-fancy = true;
      line-numbers = true;
      true-color = "always";
      # features => named groups of settings, used to keep related settings organized
      # features = "";
    };
  };

  # Git terminal UI
  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
      os.editPreset = "nvim";
      git = {
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium --oneline {{branchName}} --";
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        parseEmoji = true;
      };
      gui = {
        nerdFontsVersion = "3";
        showBottomLine = false;
        border = "rounded";
        mouseEvents = false;
      };
    };
  };
}
