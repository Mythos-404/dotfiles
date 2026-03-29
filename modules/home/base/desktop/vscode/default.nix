{
  pkgs,
  lib,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      userSettings = import ./settings {
        inherit pkgs;
        inherit lib;
      };

      extensions = import ./extensions.nix {inherit pkgs;};
    };
  };
}
