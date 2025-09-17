{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  genConfig = import ./genConfigModules.nix {inherit lib;};

  systemDir = builtins.readDir ../../systems;
  systemFiles =
    lib.filterAttrs (
      name: type:
        type == "regular" && lib.hasSuffix ".nix" name
    )
    systemDir;

  userDir = builtins.readDir ../../users;
  userNames =
    lib.filterAttrs (
      name: type:
        type == "directory"
    )
    userDir;

  mkSystem = systemFileName: let
    systemConfig = import ../../systems/${systemFileName};
    systemModules = genConfig.generateSystemModules systemFileName (systemConfig.systemConfig or {});
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs lib;

        pkgs-stable = import inputs.nixpkgs {
          system = systemConfig.systemConfig.architecture or "x86_64-linux";
          config.allowUnfree = true;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = systemConfig.systemConfig.architecture or "x86_64-linux";
          config.allowUnfree = true;
        };
      };

      modules =
        [
          ./systemConfigFramework.nix
          ./userConfigFramework.nix

          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.hostPlatform = systemConfig.systemConfig.architecture or "x86_64-linux";
          }

          ../../systems/${systemFileName}
        ]
        ++ systemModules;
    };

  mkHome = userDirName: let
    userConfig = import ../../users/${userDirName}/base.nix;
    userModules = genConfig.generateUserModules userDirName (userConfig.userConfig or {});
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      specialArgs = {
        inherit inputs lib;
      };

      modules =
        [
          ./userConfigFramework.nix
        ]
        ++ userModules;
    };
in {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];
  flake = {
    nixosConfigurations =
      lib.mapAttrs' (
        name: _:
          lib.nameValuePair (lib.removeSuffix ".nix" name) (mkSystem name)
      )
      systemFiles;

    homeConfigurations =
      lib.mapAttrs' (
        name: _:
          lib.nameValuePair name (mkHome name)
      )
      userNames;
  };
}
