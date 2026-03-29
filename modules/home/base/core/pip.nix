{
  # use mirror for pip install
  xdg.configFile."pip/pip.conf".text = ''
    [global]
    index-url = https://mirrors.ustc.edu.cn/pypi/simple
  '';

  xdg.configFile."uv/uv.toml".text = ''
    [[index]]
    url = "https://mirrors.ustc.edu.cn/pypi/simple"
    default = true
  '';
}
