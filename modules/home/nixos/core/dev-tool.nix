{pkgs, ...}:
{
  home.packages = with pkgs; [
    just # a command runner like make, but simpler
    gnumake # GNU version of make
  ];

 programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}