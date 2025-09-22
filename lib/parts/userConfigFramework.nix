{lib, ...}: {
  options.userConfig = lib.mkOption {
    type = lib.types.submodule {
      options = {
        userName = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "用户名";
        };

        homeModules = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Home Manager 额外模块列表";
        };

        profiles = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "用户配置档案列表";
        };
      };
    };
    description = "用户配置";
  };
}
