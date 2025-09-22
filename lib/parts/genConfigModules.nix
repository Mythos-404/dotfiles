{
  lib,
  inputs,
}: let
  moduleResolver = module:
    if builtins.pathExists ../../modules/${module}.nix
    then ../../modules/${module}.nix
    else ../../modules/${module};
in {
  generateUserModules = systemName: users:
    lib.flatten (
      lib.map (
        userName: let
          userDir = ../../users/${userName};

          baseConfigPath = userDir + "/base.nix";
          baseConfig =
            if builtins.pathExists baseConfigPath
            then [baseConfigPath]
            else [];
          userConfig = (import baseConfigPath).userConfig;

          homeManagerConfigPath = {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${userName}.imports = map moduleResolver userConfig.homeModules or [];
          };
          profileModules = map (profile: userDir + "/profiles/${profile}.nix") userConfig.profiles or [];

          systemConfigPath = userDir + "/per-system/${systemName}.nix";
          systemConfig =
            if builtins.pathExists systemConfigPath
            then [systemConfigPath]
            else [];
        in
          baseConfig ++ [homeManagerConfigPath] ++ profileModules ++ systemConfig
      )
      users
    );

  generateSystemModules = systemConfig: let
    hardwareModule = ../../hardware/${systemConfig.hardwareName};

    extraModules = map moduleResolver systemConfig.modules;
  in
    [hardwareModule] ++ extraModules;
}
