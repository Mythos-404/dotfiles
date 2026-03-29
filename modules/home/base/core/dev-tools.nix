{pkgs, ...}: {
  home.packages = with pkgs; [
    tokei # count lines of code, alternative to cloc

    # db related
    mycli
    pgcli
    mongosh
    sqlite
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
