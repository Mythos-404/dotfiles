{config, ...}: let
  userName = config.userConfig.userName;
in {
  home-manager.users.${userName} = {
    home.username = userName;
    home.homeDirectory = "/home/${userName}";
    home.stateVersion = "25.05";
  };
}
