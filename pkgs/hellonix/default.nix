{
  stdenv,
}: stdenv.mkDerivation {
  name = "hellonix";
  version = "1.0";
  src = ./.;
  buildPhase = ''
    echo "echo Hello, Nix!" > example
  '';
  installPhase = ''
    install -Dm755 example $out
  '';
}