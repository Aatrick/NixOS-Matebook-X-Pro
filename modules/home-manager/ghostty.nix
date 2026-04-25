{ pkgs, ... }:
{
  home.packages = [ pkgs.ghostty ];

  xdg.configFile."ghostty/config".text = ''
    window-decoration = true
    gtk-titlebar = true
    background-opacity = 0.9
    theme = Dracula
    window-width = 95
    window-height = 25
  '';
}
