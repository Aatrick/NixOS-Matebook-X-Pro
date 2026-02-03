{
  pkgs,
  lib,
  config,
  ...
}: {
  options.winter.gnome.scaling = lib.mkOption {
    type = lib.types.int;
    default = 1;
    description = "Facteur de mise à l’échelle GNOME.";
  };

  options.winter.gnome.text-scaling = lib.mkOption {
    type = lib.types.float;
    default = 1.0;
    description = "Facteur de mise à l’échelle du texte GNOME.";
  };
  config = lib.mkMerge [
    {
      services.gnome.gnome-online-accounts.enable = true;
      services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome = {
          enable = true;
          extraGSettingsOverrides = ''
            [org.gnome.mutter]
            experimental-features=['scale-monitor-framebuffer','xwayland-native-scaling','variable-refresh-rate']
          '';
        };
        xserver = {
          enable = true;
          excludePackages = with pkgs; [
            xterm
          ];
          xkb = {
            layout = lib.mkDefault "us";
            variant = "";
          };
        };
      };
    }
    {
      programs.dconf = {
        enable = true;
        profiles = {
          gdm.databases = [
            {
              settings = {
                "org/gnome/settings-daemon/plugins/color" = {
                  night-light-enabled = true;
                };
                "org/gnome/desktop/interface" = {
                  scaling-factor = lib.gvariant.mkUint32 config.winter.gnome.scaling;
                  show-battery-percentage = true;
                  text-scaling-factor = lib.gvariant.mkDouble config.winter.gnome.text-scaling;
                };
                "org/gnome/desktop/input-sources" = {
                  sources = [
                    (lib.gvariant.mkTuple [
                      "xkb"
                      "us+oss"
                    ])
                  ];
                };
              };
            }
          ];
        };
      };
    }
    {
      environment.gnome.excludePackages = with pkgs; [
        atomix # puzzle game
        cheese # webcam tool
        baobab
        snapshot
        simple-scan
        eog
        file-roller
        seahorse
        epiphany # web browser
        evince # document viewer
        geary # email reader
        gnome-characters
        gnome-music
        gnome-photos
        gnome-tour
        hitori # sudoku game
        iagno # go game
        tali # poker game
        totem # video player
        showtime
        papers
        yelp
        gnome-calculator
        gnome-calendar
        gnome-clocks
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-screenshot
        gnome-system-monitor
        #gnome-weather
        gnome-connections
        gnome-software
        gnome-disk-utility
        gnome-console
        gnome-text-editor
        nautilus
        decibels
        loupe
        cups
        simple-scan
        gnome-shell-extensions
      ];
    }
    {
      # Enable portals and MIME database so default applications can be managed via GNOME Settings
      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gnome];
        #gtkUsePortal = true;
      };
      xdg.mime.enable = true;
      environment.systemPackages = [pkgs.xdg-utils];
    }
    {
      # Is used to fix blank screen on GDM

      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;
    }
  ];
}
