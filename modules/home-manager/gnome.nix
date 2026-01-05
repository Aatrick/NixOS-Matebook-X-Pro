{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    #wineWowPackages.waylandFull
    gnome-text-editor
    gnome-calculator
    nautilus
    fastfetch
    btop
    #dconf-editor
    gnome-extension-manager

    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
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
          caffeine.extensionUuid
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
