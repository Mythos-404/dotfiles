{pkgs, ...}: {
  # live streaming
  programs.obs-studio = {
    enable = pkgs.stdenv.isx86_64;
    plugins = with pkgs.obs-studio-plugins; [
      # screen capture
      wlrobs
      droidcam-obs
      input-overlay
      obs-source-clone
      obs-shaderfilter
      obs-source-record
      obs-livesplit-one
      looking-glass-obs
      obs-vintage-filter
      obs-command-source
      obs-move-transition
      obs-backgroundremoval

      # advanced-scene-switcher
      obs-pipewire-audio-capture
      obs-vaapi
      obs-3d-effect
    ];
  };
}
