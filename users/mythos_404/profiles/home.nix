{config, ...}: let
  userName = config.userConfig.userName;
in {
  home-manager.users.${userName} = {
    imports = [./home-manager.nix];
  };
}
