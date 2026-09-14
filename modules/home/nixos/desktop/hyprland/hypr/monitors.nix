{lib, ...}: {
  monitor = {
    output = "DP-2";
    mode = "3840x2160@150.0";
    position = "0x0";
    scale = 1.25;
    bitdepth = 10;
  };

  workspace_rule = [
    {
      workspace = "1";
      monitor = "DP-5";
      default = true;
    }
    {
      workspace = "2";
      monitor = "DP-5";
    }
    {
      workspace = "3";
      monitor = "DP-5";
    }
    {
      workspace = "4";
      monitor = "DP-5";
    }
    {
      workspace = "5";
      monitor = "DP-5";
    }
    {
      workspace = "6";
      monitor = "DP-5";
    }
    {
      workspace = "7";
      monitor = "DP-5";
    }
    {
      workspace = "8";
      monitor = "DP-5";
    }
    {
      workspace = "9";
      monitor = "DP-5";
    }
    {
      workspace = "10";
      monitor = "DP-5";
    }
  ];
}
