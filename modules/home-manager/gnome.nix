{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    #wineWowPackages.waylandFull
    #gnome-text-editor
    gnome-calculator
    nautilus
    fastfetch
    btop
    #dconf-editor
    gnome-extension-manager

    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    gnomeExtensions.places-status-indicator
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.weather-oclock
    gnomeExtensions.apps
    gnomeExtensions.just-perfection
    # Icons
    pkgs-unstable.papirus-icon-theme
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/about" = "app.zen_browser.zen.desktop";
      "x-scheme-handler/unknown" = "app.zen_browser.zen.desktop";
    };

    associations.added = {
      "text/html" = [ "app.zen_browser.zen.desktop" ];
      "x-scheme-handler/http" = [ "app.zen_browser.zen.desktop" ];
      "x-scheme-handler/https" = [ "app.zen_browser.zen.desktop" ];
    };
  };
  

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          dash-to-dock.extensionUuid
          user-themes.extensionUuid
          appindicator.extensionUuid
          places-status-indicator.extensionUuid
          quick-settings-audio-panel.extensionUuid
          weather-oclock.extensionUuid
          apps.extensionUuid
          just-perfection.extensionUuid
        ];
      };
    };
  };
}
