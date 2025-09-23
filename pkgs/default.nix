{pkgs, ...}: let
  inherit (pkgs) stdenv;
in {
  grub-theme-angle = pkgs.callPackage ./grub-theme-angle {inherit stdenv;};
}
