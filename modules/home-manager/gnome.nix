{ pkgs, pkgs-unstable, lib, ... }: {
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
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
    # Icons
    pkgs-unstable.papirus-icon-theme
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "io.github.zen_browser.zen.desktop";
      "x-scheme-handler/http" = "io.github.zen_browser.zen.desktop";
      "x-scheme-handler/https" = "io.github.zen_browser.zen.desktop";
      "x-scheme-handler/about" = "io.github.zen_browser.zen.desktop";
      "x-scheme-handler/unknown" = "io.github.zen_browser.zen.desktop";
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
	          caffeine.extensionUuid
	          appindicator.extensionUuid
	          places-status-indicator.extensionUuid
            quick-settings-audio-panel.extensionUuid
            weather-oclock.extensionUuid
        ];
      };
    };
  };
}
