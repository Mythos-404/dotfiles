{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool # GUI for fcitx5
      fcitx5-gtk # gtk im module

      (
        fcitx5-rime.override {
          rimeDataPkgs = [pkgs.rime-ice];
        }
      )
      librime
      librime-lua
    ];
  };
  xdg.dataFile."fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;
}
