{ pkgs, pkgs-unstable, config, lib, ... }:

let
  open-webui-shortcut = pkgs.makeDesktopItem {
    name = "Open WebUI";
    desktopName = "IA local";
    exec = "${pkgs.xdg-utils}/bin/xdg-open http://localhost:8080"; # Commande pour exécuter l'application
    icon = "wechat"; # Chemin vers l'icône
    comment = "Acceder a l'ia locale";
    categories = [ "Utility" ];
  };
in
{
  options.winter.ollama.acceleration = lib.mkOption {
    description = "ollama acceleration";
    type = lib.types.nullOr lib.types.str;
    default = null;
  };

  config = {
    environment.systemPackages = [
      pkgs.ollama
      open-webui-shortcut
    ];

    services.open-webui = {
      package = pkgs-unstable.open-webui;
      enable = true;
      port = 8080;
    };

    services.ollama = {
      enable = true;
      loadModels = [ "qwen3:8b" ];
      acceleration = config.winter.ollama.acceleration; # use cuda if nvidia, rocm if amd, and cpu only otherwise
    };
  };
}
