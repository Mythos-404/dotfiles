{lib, ...}:
lib.mkMerge (map (path: import path {inherit lib;}) (lib.utils.scanPaths ./.))
