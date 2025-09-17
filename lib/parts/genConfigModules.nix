{lib}: rec {
  moduleResolver = module:
    if builtins.pathExists ../../modules/${module}.nix
    then ../../modules/${module}.nix
    else ../../modules/${module};

  generateSystemModules = systemName: systemConfig: let
    hardwareModule = ../../hardware/${systemConfig.hardwareName};

    extraModules = map moduleResolver systemConfig.modules;

    userBaseConfigs = map (userName: ../../users/${userName}/base.nix) systemConfig.users;
    userSystemConfigs = lib.flatten (
      map (
        userName: let
          userSystemConfigPath = ../../users/${userName}/per-system/${systemName}.nix;
        in
          if builtins.pathExists userSystemConfigPath
          then [userSystemConfigPath]
          else []
      )
      systemConfig.users
    );
  in
    [hardwareModule] ++ extraModules ++ userBaseConfigs ++ userSystemConfigs;

  generateUserModules = userDirName: userConfig: let
    extraModules = map moduleResolver userConfig.homeManagerModules;
    profileModules = map (profile: userDirName + "/profiles/${profile}.nix") userConfig.profiles;
  in
    extraModules ++ profileModules;
}
