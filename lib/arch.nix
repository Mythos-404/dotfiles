{lib}: let
  darwinArchs = [
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  linuxArchs = [
    "x86_64-linux"
    "aarch64-linux"
    "i686-linux"
    "riscv64-linux"
  ];
in {
  inherit darwinArchs linuxArchs;

  isDarwin = architecture: builtins.elem architecture darwinArchs;

  isLinux = architecture: builtins.elem architecture linuxArchs;

  getPlatformType = architecture:
    if builtins.elem architecture linuxArchs
    then "linux"
    else if builtins.elem architecture darwinArchs
    then "darwin"
    else throw "Unsupported architecture: ${architecture}";
}
