{
  networking.hostName = "acacia";

  systemConfig = {
    architecture = "x86_64-linux";
    hardwareName = "acacia";

    users = [
      "mythos_404"
    ];

    modules = [
      "core"

      "desktop/peripherals"
    ];
  };

  system.stateVersion = "25.05";
}
