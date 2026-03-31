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
      "desktop/hyprland"

      # "services/kmscon"
      "services/virtualisation"
    ];
  };

  system.stateVersion = "25.05";
}
