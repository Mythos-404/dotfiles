{lib}: {
  loadPackages = packagesDir: let
    packagePaths =
      builtins.readDir packagesDir
      |> lib.mapAttrsToList (
        name: type: {
          name = lib.removeSuffix ".nix" name;
          path =
            if type == "directory"
            then "${packagesDir}/${name}"
            else "${packagesDir}/${name}.nix";
        }
      );

    generateOverlay = final: prev:
      packagePaths
      |> map (
        pkg: let
          packageDef = import pkg.path {
            pkgs = final;
            lib = lib;
            config = {};
          };
        in {
          name = pkg.name;
          value = packageDef.package or (throw "Package ${pkg.name} must export 'package' attribute");
        }
      )
      |> builtins.listToAttrs;

    generateModule = {
      config,
      pkgs,
      lib,
      ...
    }: let
      packageModules =
        packagePaths
        |> map (
          pkg: let
            packageDef = import pkg.path {
              inherit pkgs lib config;
            };
          in {
            options = packageDef.options or {};
            config = packageDef.config or {};
          }
        );
    in {
      options = lib.foldl' (acc: mod: acc // mod.options) {} packageModules;
      config =
        packageModules |> map (mod: mod.config) |> lib.mkMerge;
    };
  in {
    overlay = generateOverlay;
    module = generateModule;
  };
}
