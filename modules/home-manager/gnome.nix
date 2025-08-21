{ pkgs, pkgs-unstable, lib, ... }: {
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
  home.packages = with pkgs; [
    wineWowPackages.waylandFull
    gnome-text-editor
    gnome-calculator
    file-roller
    nautilus

    fastfetch
    htop
    gnome-tweaks
    dconf-editor
    gnome-extension-manager
    steam-run

    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.light-style
    gnomeExtensions.caffeine
    gnomeExtensions.user-themes
    gnomeExtensions.places-status-indicator
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.weather-oclock
    # Icons
    pkgs-unstable.papirus-icon-theme
  ];

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
	          light-style.extensionUuid
	          places-status-indicator.extensionUuid
            quick-settings-audio-panel.extensionUuid
            weather-oclock.extensionUuid
        ];
        favorite-apps = ["vesktop.desktop"
            "spotify.desktop"
            "brave-browser.desktop"
            "com.raggesilver.BlackBox.desktop"
            "code.desktop"
            ];
      };
      "org/gnome/nautilus/list-view" = {
          use-tree-view = true;
      };
      "org/gnome/desktop/privacy" = {
          old-files-age = 1;
          remove-old-temp-files = true;
          remove-old-trash-files = true;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
          speed = 0.18;
      };
      "org/gnome/desktop/interface" = {
            accent-color = "teal";
            color-scheme = "prefer-dark";
            icon-theme = "Papirus";
            show-battery-percentage = true;
            toolbar-style = "text";
            gtk-theme = "Adwaita";
            text-scaling-factor = 0.95;
        };
      "org/gnome/desktop/app-folders" ={
        folder-children = ["System" "Utilities" "YaST" "Pardus" "SysApps"];
      };
      "org/gnome/desktop/app-folders/folders/Utilities" = {
        apps = ["org.gnome.Connections.desktop" "org.gnome.Evince.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "com.mattjakeman.ExtensionManager.desktop" "ca.desrt.dconf-editor.desktop" "org.gnome.tweaks.desktop" "org.gnome.Calculator.desktop"];
      };
      "org/gnome/desktop/app-folders/folders/SysApps" = {
        apps = ["org.gnome.Extensions.desktop" "org.gnome.Settings.desktop" "org.gnome.FileRoller.desktop" "cmake-gui.desktop" "htop.desktop" "fish.desktop" "nixos-manual.desktop" "vlc.desktop" "io.github.Foldex.AdwSteamGtk.desktop"];
      };
      "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
        };
        "org/desktop/vm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
        };
      "org/gnome/shell/extensions/weather-oclock" = {
        weather-after-clock = true;
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
       	show-icons-emblems = false;
      	  show-show-apps-button = false;
       	show-trash = false;
       	transparency-mode = "FIXED";
       	custom-theme-shrink = true;
       	dash-max-icon-size = 32;
       	background-opacity = 0.3;
	      };
      "org/gnome/desktop/privacy".hide-identity = true;
      "org/gnome/SessionManager".logout-prompt = false;
      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock".blur = false;
      "org/gnome/TextEditor" = {
        indent-style = "space";
        restore-session = true;
        show-right-margin = false;
        style-scheme = "Adwaita";
        tab-width = lib.hm.gvariant.mkUint32 2;
        use-system-font = true;
      };
      "org/gnome/gnome-session".logout-prompt = false;
      "com/raggesilver/BlackBox" = {
        	custom-shell-command = "/run/current-system/sw/bin/fish";
        	easy-copy-paste = true;
        	floating-controls = true;
        	font = "Adwaita Mono 12";
        	opacity = 100;
        	pretty = true;
        	remember-window-size = true;
        	scrollback-mode = false;
        	show-headerbar = false;
        	show-scrollbars = false;
        	terminal-bell = false;
        	theme-bold-is-bright = false;
        	theme-dark = "Dracula";
        	use-custom-command = true;
        	terminal-padding = 10;
        	floating-controls-hover-area = 30;
        	delay-before-showing-floating-controls = 100;
      };
      "org/gnome/nautilus/list-view" = {
      	  default-zoom-level = "small";
      };
      "org/gnome/nautilus/preferences" = {
        	default-folder-viewer = "list-view";
      };
    };
  };
}
