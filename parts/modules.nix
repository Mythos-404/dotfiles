{
  lib,
  inputs,
}: let
  moduleResolver = basePath: architecture: module: let
    platform' = lib.arch.getPlatformType architecture;
    platform =
      if platform' == "linux"
      then "nixos"
      else platform';
    platformPath = ./${basePath}/${platform}/${module};
    platformPathNix = ./${basePath}/${platform}/${module}.nix;
  in
    if builtins.pathExists platformPathNix
    then platformPathNix
    else if builtins.pathExists platformPath
    then platformPath
    else throw "Module not found: ${platformPath}(.nix)";

  systemModuleResolver = moduleResolver "../modules/system";
  homeModuleResolver = moduleResolver "../modules/home";
in {
  generateUserModules = systemName: architecture: users:
    users
    |> lib.map (
      userName: let
        userDir = ../users/${userName};

        baseConfigPath = userDir + "/base.nix";
        baseConfig =
          if builtins.pathExists baseConfigPath
          then [baseConfigPath]
          else [];
        userConfig = (import baseConfigPath).userConfig;

        homeManagerConfigPath = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userName}.imports =
            [../modules/home/base]
            ++ (
              (userConfig.homeModules or [])
              |> map (module: homeModuleResolver architecture module)
            );
        };
        profileModules = map (profile: userDir + "/profiles/${profile}.nix") (userConfig.profiles or []);

        systemConfigPath = userDir + "/per-system/${systemName}.nix";
        systemConfig =
          if builtins.pathExists systemConfigPath
          then [systemConfigPath]
          else [];
      in
        baseConfig ++ [homeManagerConfigPath] ++ profileModules ++ systemConfig
    )
    |> lib.flatten;

  generateSystemModules = architecture: systemConfig: let
    hardwareModule = ../hardware/${systemConfig.hardwareName};
    extraModules =
      [../modules/system/base]
      ++ (
        (systemConfig.modules or [])
        |> map (systemModuleResolver architecture)
      );
  in
    [hardwareModule] ++ extraModules;
}
