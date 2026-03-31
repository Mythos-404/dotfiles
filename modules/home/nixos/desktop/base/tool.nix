{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard # copying and pasting
    cliphist # clipboard history
    brightnessctl

    # audio
    pamixer # CLI pulseaudio mixer
    alsa-utils # provides amixer/alsamixer/...

    # notification
    libnotify # provides notify-send

    # screenshot/screencast
    hyprshot # screenshot tool
    wf-recorder # screen recording
    slurp # select region
    grim # screenshot
    swappy # screenshot annotation tool
    hyprpicker # color picker

    # launcher
    rofi

    # misc
    jq # json processor (used by scripts)

    # ocr
    tesseract
  ];
}
