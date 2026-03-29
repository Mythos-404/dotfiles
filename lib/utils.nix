{lib, ...}: {
  relativeToRoot = lib.path.append ../.;

  scanPaths = path:
    builtins.readDir path
    |> lib.attrsets.filterAttrs (
      path: type:
        (type == "directory")
        || (
          (path != "default.nix")
          && (lib.strings.hasSuffix ".nix" path)
        )
    )
    |> builtins.attrNames
    |> builtins.map (f: (path + "/${f}"));

  mergeUserGroups = config: groups:
    (config.systemConfig.users or [])
    |> map (username: {${username}.extraGroups = groups;})
    |> lib.mkMerge;
}
