{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard # copying and pasting
    brightnessctl
    # audio
    alsa-utils # provides amixer/alsamixer/...
    # screenshot/screencast
    hyprshot # screenshot tool
    wf-recorder # screen recording
    slurp # select region
    grim # screenshot
    swappy # screenshot annotation tool
    hyprpicker # color picker
    # ocr
    tesseract
  ];
}
