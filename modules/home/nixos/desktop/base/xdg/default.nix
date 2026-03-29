{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = lib.utils.scanPaths ./.;

  home.packages = with pkgs; [
    xdg-utils # provides cli tools such as `xdg-mime` `xdg-open`
    xdg-user-dirs
  ];

  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "dkt";
      documents = "doc";
      download = "dls";
      music = "mus";
      pictures = "pic";
      publicShare = "psh";
      templates = "tpl";
      videos = "vid";

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
