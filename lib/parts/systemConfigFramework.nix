{lib, ...}: {
  options.systemConfig = lib.mkOption {
    type = lib.types.submodule {
      options = {
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "系统用户列表";
        };

        architecture = lib.mkOption {
          type = lib.types.str;
          description = "系统架构";
        };

        hardwareName = lib.mkOption {
          type = lib.types.str;
          description = "硬件配置名称";
        };

        modules = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "额外模块列表";
        };
      };
    };
    description = "系统配置";
  };
}
