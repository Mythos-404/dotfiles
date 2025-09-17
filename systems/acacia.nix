{
  networking.hostName = "acacia";

  systemConfig = {
    architecture = "x86_64-linux";
    hardwareName = "acacia";

    users = [
      "mythos_404"
    ];

    modules = [
      "core/nix"
      "core/i18n"
      "core/fonts"

      "desktop/peripherals"

      # "services/kmscon"
    ];
  };

  system.stateVersion = "25.05";
}
