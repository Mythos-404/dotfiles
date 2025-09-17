{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
      material-design-icons
      font-awesome

      nerd-fonts.symbols-only
      nerd-fonts.iosevka

      noto-fonts
      noto-fonts-color-emoji

      source-sans
      source-serif
      source-han-sans
      source-han-serif
      source-han-mono

      lxgw-wenkai-screen

      sarasa-gothic
      maple-mono.NF-CN-unhinted
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Source Serif 4"
          "Source Han Sans SC"
          "Source Han Sans TC"
        ];
        sansSerif = [
          "Source Serif 4"
          "LXGW WenKai Screen"
          "Source Han Sans SC"
          "Source Han Sans TC"
        ];
        monospace = [
          "Maple Mono NF CN"
          "Source Han Mono SC"
          "Source Han Mono TC"
          "Iosevka Nerd Font"
        ];
        emoji = ["Noto Color Emoji"];
      };
      antialias = true;
      hinting.enable = false;
      subpixel = {
        rgba = "rgb";
      };
    };
  };
}
