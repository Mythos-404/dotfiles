{lib, ...}: {
  # Allow unfree packages
  nixpkgs.config.alowUnfree = lib.mkForce true;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
}
