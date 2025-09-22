{stdenv}:
stdenv.mkDerivation {
  pname = "grub-theme-angle";
  version = "1.0.0";

  src = ./theme;

  installPhase = ''
    cp -r $src $out
  '';
}
