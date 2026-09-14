let
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPsxXlbQ6+6E2wp/2Evy9bI1A/F6RK4ox7kKv7hVQHs root@acacia";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINuOAIK2HhweHLyZfTFm3Sq5hzGGB9/DRfHZ6vv1krFI mythos_404@outlook.com";
in {
  "nix-access-tokens.age".publicKeys = [host user];
}
