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
      setSessionVariables = true;

      desktop = "${config.home.homeDirectory}/dkt";
      documents = "${config.home.homeDirectory}/doc";
      download = "${config.home.homeDirectory}/dls";
      projects = "${config.home.homeDirectory}/pjs";
      music = "${config.home.homeDirectory}/mus";
      pictures = "${config.home.homeDirectory}/pic";
      publicShare = "${config.home.homeDirectory}/psh";
      templates = "${config.home.homeDirectory}/tpl";
      videos = "${config.home.homeDirectory}/vid";

      extraConfig = {
        SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
