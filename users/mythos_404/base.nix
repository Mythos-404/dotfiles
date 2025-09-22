let
  userName = "mythos_404";
in {
  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
  };

  home-manager.users.${userName} = {
    home.username = userName;
    home.homeDirectory = "/home/${userName}";
    home.stateVersion = "25.05";
  };

  userConfig = {
    userName = userName;

    homeModules = [
      "home/home"
    ];
  };
}
