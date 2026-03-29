{
  config,
  pkgs,
  ...
}: {
  programs.zsh.enable = true;
  users.users.${config.userConfig.userName} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
}
