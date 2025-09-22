{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  genConfig = import ./genConfigModules.nix {inherit lib inputs;};

  systemDir = builtins.readDir ../../systems;
  systemFiles =
    lib.filterAttrs (
      name: type:
        type == "regular" && lib.hasSuffix ".nix" name
    )
    systemDir;

  mkSystem = systemFileName: let
    systemName = lib.removeSuffix ".nix" systemFileName;
    systemConfig = import ../../systems/${systemFileName};

    userModules =
      genConfig.generateUserModules
      systemName
      (systemConfig.systemConfig.users or []);

    systemModules =
      genConfig.generateSystemModules
      (systemConfig.systemConfig or {});
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

          inputs.home-manager.nixosModules.home-manager
        ]
        ++ systemModules
        ++ userModules;
    };
in {
  flake = {
    nixosConfigurations =
      lib.mapAttrs' (
        name: _:
          lib.nameValuePair (lib.removeSuffix ".nix" name) (mkSystem name)
      )
      systemFiles;
  };
}
