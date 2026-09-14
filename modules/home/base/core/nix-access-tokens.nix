{config, ...}: {
  age.secrets.nix-access-tokens.file = ../../../../secrets/nix-access-tokens.age;

  home.file.".config/nix/nix.conf".text = ''
    experimental-features = nix-command flakes pipe-operators
    !include ${config.age.secrets.nix-access-tokens.path}
  '';
}
