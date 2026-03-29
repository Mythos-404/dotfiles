{...}: {
  home.sessionVariables = {
    TERMINAL = "kitty -1";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Maple Mono NF CN";
      size = 13;
    };

    settings = {
      shell_integration = true;
      macos_option_as_alt = true; # Option key acts as Alt on macOS
      enable_audio_bell = false;
    };

    # macOS specific settings
    darwinLaunchOptions = ["--start-as=maximized"];
  };
}
