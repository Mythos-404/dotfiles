{config, ...}: {
  age.secrets.nix-access-tokens.file = ../../../secrets/nix-access-tokens.age;
  nix.extraOptions = "!include ${config.age.secrets.nix-access-tokens.path}";
}
