{
  inputs,
  lib,
  ...
}: let
  # 复用 systems.nix 里同样的扩展 lib (提供 lib.utils / lib.arch / lib.packages)
  extendedLib = lib.extend (
    final: prev:
      builtins.readDir ../lib
      |> lib.filterAttrs (
        name: type:
          type == "regular" && lib.hasSuffix ".nix" name
      )
      |> lib.attrNames
      |> map (n: {
        name = lib.removeSuffix ".nix" n;
        value = import ../lib/${n} {lib = final;};
      })
      |> builtins.listToAttrs
  );

  packages = extendedLib.packages.loadPackages ../pkgs;

  systemFileNames =
    builtins.readDir ../systems
    |> lib.filterAttrs (
      name: type:
        type == "regular" && lib.hasSuffix ".nix" name
    )
    |> lib.attrNames;

  getSystemConfig = fileName: let
    rawConfig = import ../systems/${fileName};
  in
    if builtins.isFunction rawConfig
    then
      rawConfig {
        pkgs = null;
        lib = extendedLib;
        config = {};
      }
    else rawConfig;

  homeModuleResolver = architecture: module: let
    platform =
      if extendedLib.arch.isLinux architecture
      then "nixos"
      else "darwin";
    dir = ../modules/home/${platform}/${module};
    file = ../modules/home/${platform}/${module}.nix;
  in
    if builtins.pathExists file
    then file
    else if builtins.pathExists dir
    then dir
    else throw "Module not found: ${toString dir}(.nix)";

  mkHomeConfiguration = systemName: userName: let
    systemConfig = getSystemConfig "${systemName}.nix";
    architecture = systemConfig.systemConfig.architecture or "x86_64-linux";
    mergedInputs = inputs // (systemConfig.systemConfig.inputsOverride or {});
    userDir = ../users/${userName};
    userConfig = (import (userDir + "/base.nix")).userConfig;

    pkgs = import mergedInputs.nixpkgs {
      system = architecture;
      config.allowUnfree = true;
      overlays = [
        packages.overlay
        mergedInputs.nix4vscode.overlays.default
        mergedInputs.yazi.overlays.default
      ];
    };
  in
    mergedInputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      lib = extendedLib;
      extraSpecialArgs = {inherit inputs;};
      modules =
        [
          ../modules/home/base
          (userDir + "/profiles/home-manager.nix")
          mergedInputs.agenix.homeManagerModules.default
        ]
        ++ map (homeModuleResolver architecture) (userConfig.homeModules or []);
    };

  homeConfigurations =
    systemFileNames
    |> lib.concatMap (
      fileName: let
        systemName = lib.removeSuffix ".nix" fileName;
        systemConfig = getSystemConfig fileName;
        architecture = systemConfig.systemConfig.architecture or "x86_64-linux";
      in
        if !extendedLib.arch.isLinux architecture
        then []
        else
          (systemConfig.systemConfig.users or [])
          |> map (userName: lib.nameValuePair "${userName}@${systemName}" (mkHomeConfiguration systemName userName))
    );
in {
  flake.homeConfigurations = builtins.listToAttrs homeConfigurations;
}
