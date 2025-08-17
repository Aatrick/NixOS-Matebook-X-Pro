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
    gnomeExtensions.tiling-shell
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
            tiling-shell.extensionUuid
        ];
      };
      "org/gnome/desktop/interface" = {
            icon-theme = "Papirus";
            show-battery-percentage = true;
            toolbar-style = "text";
            gtk-theme = "Adwaita";
        };
      "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
        };
        "org/desktop/vm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
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
      "org/gnome/shell/extensions/tilingshell" = {
            enable-autotiling = true;
            show-indicator = false;
            enable-screen-edges-windows-suggestions = true;
            enable-smart-window-border-radius = true;
            enable-snap-assistant-windows-suggestions = true;
            enable-tiling-system-windows-suggestions = true;
            enable-window-border = false;
            focus-window-down = ["<Control><Super>Down"];
            focus-window-left = ["<Control><Super>Left"];
            focus-window-right = ["<Control><Super>Right"];
            focus-window-up = ["<Control><Super>Up"];
            highlight-current-window = ["''"];
            inner-gaps = lib.hm.gvariant.mkUint32 6;
            snap-assistant-threshold = lib.hm.gvariant.mkInt32 20;
            layouts-json = builtins.toJSON [
                {
                    id =  "2 windows";
                    tiles = [
                        {
                            x = 0;
                            y = 0;
                            width = 0.5663145539906104;
                            height = 1;
                            groups = [1];
                        }
                        {
                            x = 0.5663145539906104;
                            y = 0;
                            width = 0.4336854460093899;
                            height = 1;
                            groups = [2 1];
                        }
                    ];
                }
                {
                    id =  "3 windows";
                    tiles = [
                        {
                            x = 0;
                            y = 0;
                            width = 0.5663145539906104;
                            height = 1;
                            groups = [1];
                        }
                        {
                            x = 0.5663145539906104;
                            y = 0;
                            width = 0.4336854460093899;
                            height = 0.4995159728944821;
                            groups = [2 1];
                        }
                        {
                            x = 0.5663145539906104;
                            y = 0.4995159728944821;
                            width = 0.4336854460093899;
                            height = 0.500484027105518;
                            groups = [2 1];
                        }
                    ];
                }
            ];
            selected-layouts = [["2 windows"] ["2 windows"]];
            outer-gaps = lib.hm.gvariant.mkUint32 6;
            overriden-window-menu = true;
            top-edge-maximise = true;
            untile-window = ["<Super>d"];
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
