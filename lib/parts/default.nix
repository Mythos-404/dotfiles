{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  mylib = import ../default.nix {inherit lib;};

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
        inherit inputs lib mylib;

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
          inputs.home-manager.nixosModules.home-manager

          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.hostPlatform = systemConfig.systemConfig.architecture or "x86_64-linux";
          }

          {
            home-manager.extraSpecialArgs = {
              inherit mylib inputs;
            };
          }

          ../../systems/${systemFileName}
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
