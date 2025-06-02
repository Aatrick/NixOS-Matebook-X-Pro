{ pkgs, pkgs-unstable, ... }:

let
  open-webui-shortcut = pkgs.makeDesktopItem {
    name = "Open WebUI";
    desktopName = "IA llama 3.2";
    exec = "${pkgs.xdg-utils}/bin/xdg-open http://localhost:8080"; # Commande pour exécuter l'application
    icon = "wechat"; # Chemin vers l'icône
    comment = "Acceder a l'ia locale";
    categories = [ "Utility" ];
  };
in
{
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
    loadModels = [ "llama3.2:3b" ];
    acceleration = null; # use cuda if nvidia, rocm if amd, and cpu only otherwise
  };
}
