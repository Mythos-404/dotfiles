{...}: let
  userName = "mythos_404";
in {
  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
  };

  userConfig = {
    userName = userName;
  };
}
