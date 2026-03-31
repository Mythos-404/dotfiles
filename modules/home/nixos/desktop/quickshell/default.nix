{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."quickshell".source = ./config;

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/quickshell";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
