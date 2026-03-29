{
  inputs,
  lib,
  ...
}: let
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
  genModules = import ./modules.nix {
    lib = extendedLib;
    inputs = inputs;
  };

  systemNames =
    builtins.readDir ../systems
    |> lib.filterAttrs (
      name: type:
        type == "regular" && lib.hasSuffix ".nix" name
    );

  mkSystem = systemFileName: let
    systemName = lib.removeSuffix ".nix" systemFileName;

    systemConfig = let
      rawConfig = import ../systems/${systemFileName};
    in
      if builtins.isFunction rawConfig
      then
        rawConfig {
          pkgs = null;
          lib = extendedLib;
          config = {};
        }
      else rawConfig;

    architecture = systemConfig.systemConfig.architecture or "x86_64-linux";

    mergedInputs = inputs // (systemConfig.systemConfig.inputsOverride or {});

    userModules = genModules.generateUserModules systemName architecture (systemConfig.systemConfig.users or []);
    systemModules = genModules.generateSystemModules architecture (systemConfig.systemConfig or {});

    buildSystemConfig =
      if extendedLib.arch.isDarwin architecture
      then {
        builder = mergedInputs.nix-darwin.lib.darwinSystem;
        nixpkgsInput = mergedInputs.nixpkgs-darwin;
        nixpkgsStableInput = mergedInputs.nixpkgs-darwin or mergedInputs.nix-darwin;
        nixpkgsUnstableInput = mergedInputs.nixpkgs-unstable or mergedInputs.nixpkgs-darwin;
        platformModules =
          [
            # Darwin 特定模块
          ]
          ++ (
            if mergedInputs ? home-manager && mergedInputs.home-manager ? darwinModules
            then [mergedInputs.home-manager.darwinModules.home-manager]
            else []
          );
      }
      else if extendedLib.arch.isLinux architecture
      then {
        builder = mergedInputs.nixpkgs.lib.nixosSystem;
        nixpkgsInput = mergedInputs.nixpkgs;
        nixpkgsStableInput = mergedInputs.nixpkgs-stable or mergedInputs.nixpkgs;
        nixpkgsUnstableInput = mergedInputs.nixpkgs-unstable or mergedInputs.nixpkgs;
        platformModules =
          [
            # NixOS 特定模块
          ]
          ++ (
            if mergedInputs ? home-manager && mergedInputs.home-manager ? nixosModules
            then [mergedInputs.home-manager.nixosModules.home-manager]
            else []
          );
      }
      else throw "Unsupported architecture: ${architecture}";

    systemBuildArgs = {
      specialArgs = {
        inputs = mergedInputs;
        systemName = systemName;
        lib = extendedLib;

        pkgs-stable = import buildSystemConfig.nixpkgsStableInput {
          system = architecture;
          config.allowUnfree = true;
        };

        pkgs-unstable = import buildSystemConfig.nixpkgsUnstableInput {
          system = architecture;
          config.allowUnfree = true;
        };
      };

      modules =
        [
          ./options/system.nix
          ./options/user.nix

          {
            nixpkgs.overlays = [
              packages.overlay

              inputs.nix-cachyos-kernel.overlays.default
              inputs.nix4vscode.overlays.default

              inputs.yazi.overlays.default
            ];
          }
          packages.module

          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.hostPlatform = systemConfig.systemConfig.architecture or "x86_64-linux";
          }

          {
            home-manager.extraSpecialArgs = {
              inputs = mergedInputs;
            };
          }

          ../systems/${systemFileName}
        ]
        ++ buildSystemConfig.platformModules
        ++ systemModules
        ++ userModules;
    };
  in
    buildSystemConfig.builder systemBuildArgs;

  systemFilter = predicate:
    systemNames
    |> lib.filterAttrs (
      name: _: let
        systemConfig = let
          rawConfig = import ../systems/${name};
        in
          if builtins.isFunction rawConfig
          then
            rawConfig {
              pkgs = null;
              lib = extendedLib;
              config = {};
            }
          else rawConfig;

        architecture = systemConfig.systemConfig.architecture or "x86_64-linux";
      in
        predicate architecture
    );

  darwinSystems = systemFilter extendedLib.arch.isDarwin;
  nixosSystems = systemFilter extendedLib.arch.isLinux;
in {
  flake = {
    nixosConfigurations =
      nixosSystems
      |> lib.mapAttrs' (
        name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (mkSystem name)
      );

    darwinConfigurations =
      darwinSystems
      |> lib.mapAttrs' (
        name: _: lib.nameValuePair (lib.removeSuffix ".nix" name) (mkSystem name)
      );
  };
}
