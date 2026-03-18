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
        # gnome-weather
        gnome-connections
        gnome-software
        gnome-disk-utility
        gnome-console
        # gnome-text-editor
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
      environment.systemPackages = [pkgs.xdg-utils pkgs.iio-sensor-proxy];
    }
    {
      # Ensure brightnessctl is installed so the script can control the backlight
      environment.systemPackages = with pkgs; [
        brightnessctl
      ];

      # Create the user service
      systemd.user.services.ambient-brightness-workaround = {
        description = "Custom Ambient Light to Backlight Daemon";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];

        # Inject dependencies directly into the script's PATH
        path = with pkgs; [ iio-sensor-proxy brightnessctl coreutils gnugrep gnused ];

        script = ''
          stdbuf -oL monitor-sensor | grep --line-buffered "Light changed" | while read -r line; do
            lux=$(echo "$line" | sed -E 's/.*Light changed: ([0-9]+)[,.].*/\1/')
            if [ -z "$lux" ]; then continue; fi

            # more granular brightness targets
            if [ "$lux" -le 5 ]; then
              target="1%"
            elif [ "$lux" -le 10 ]; then
              target="5%"
            elif [ "$lux" -le 30 ]; then
              target="10%"
            elif [ "$lux" -le 60 ]; then
              target="20%"
            elif [ "$lux" -le 120 ]; then
              target="30%"
            elif [ "$lux" -le 240 ]; then
              target="40%"
            elif [ "$lux" -le 480 ]; then
              target="60%"
            elif [ "$lux" -le 960 ]; then
              target="80%"
            else
              target="100%"
            fi

            # Only apply if the target is different from current to save CPU/Battery
            current=$(brightnessctl -m | cut -d, -f4)
            if [ "$target" != "$current" ]; then
              brightnessctl set "$target" -q
            fi
          done
        '';
        serviceConfig = {
          Restart = "always";
          RestartSec = 5;
        };
      };
    }
  ];
}
