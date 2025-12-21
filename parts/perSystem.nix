{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = {
    lib,
    pkgs,
    config,
    ...
  }: {
    pre-commit = {
      inherit pkgs;
      settings = {
        hooks = {
          alejandra.enable = true;
          just = {
            enable = true;
            name = "just";
            description = "Format just files";
            files = "Justfile";
            entry = "bash -c 'for f in \"$@\"; do ${lib.getExe pkgs.just} --fmt --unstable --justfile $f; done'";
          };
          markdownlint.enable = true;
          ripsecrets.enable = true;
          trim-trailing-whitespace.enable = true;
        };
      };
    };

    treefmt = {
      projectRootFile = "flake.lock";

      programs = {
        alejandra.enable = true;
        just.enable = true;
        mdformat.enable = true;
      };

      settings.formatter = {
        just.includes = ["Justfile"];
      };

      settings.global.excludes = [".envrc" "LICENSE"];
    };

    devShells.default = pkgs.mkShell {
      name = "dotfiles";

      packages = with pkgs; [
        # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
        bashInteractive

        # Nix-related
        alejandra
        treefmt
        nil
        nixd
      ];

      shellHook = ''
        ${config.pre-commit.shellHook}
      '';

      formatter = config.treefmt.build.wrapper;
    };
  };
}
