{lib, ...}:
builtins.foldl' (acc: f: acc // (import f)) {} (lib.utils.scanPaths ./.)
