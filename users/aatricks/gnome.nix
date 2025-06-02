{ pkgs, pkgs-unstable, lib, ... }: {
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.light-style
    gnomeExtensions.caffeine
    gnomeExtensions.user-themes
    gnomeExtensions.places-status-indicator
    # Icons
    pkgs-unstable.epapirus-icon-theme
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
        ];
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
        	delay-before-showing-floating-controls = 100;
        	easy-copy-paste = true;
        	floating-controls = true;
        	floating-controls-hover-area=30;
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
