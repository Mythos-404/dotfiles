{lib, ...}:
lib.mkMerge (map import (lib.utils.scanPaths ./.))
