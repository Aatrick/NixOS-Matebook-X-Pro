{ pkgs, pkgs-unstable, config, lib, ... }:

{
  options.winter.ollama.acceleration = lib.mkOption {
    description = "ollama acceleration";
    type = lib.types.nullOr lib.types.str;
    default = null;
  };

  config = {
    environment.systemPackages = [
      pkgs.ollama
      # open-webui-shortcut
      pkgs-unstable.newelle
    ];

    # services.open-webui = {
    #   package = pkgs.open-webui;
    #   enable = true;
    #   port = 8080;
    # };

    services.ollama = {
      enable = true;
      loadModels = [ "qwen3:8b" ];
      acceleration = config.winter.ollama.acceleration; # use cuda if nvidia, rocm if amd, and cpu only otherwise
    };
  };
}
