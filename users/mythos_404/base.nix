{...}: let
  userName = "mythos_404";
in {
  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  userConfig = {
    userName = userName;
  };
}
