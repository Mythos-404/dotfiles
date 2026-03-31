{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool
      fcitx5-gtk

      (fcitx5-rime.override {
        rimeDataPkgs = [pkgs.rime-ice];
      })
      librime
      librime-lua
    ];
  };
}
