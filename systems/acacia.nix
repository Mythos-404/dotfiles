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
      "desktop"

      "services/kmscon"
      "services/virtualisation"
    ];
  };

  system.stateVersion = "25.05";
}
