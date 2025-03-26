{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/huawei/machc-wa>
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
    
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import <unstable> {
        config = config.nixpkgs.config;
      };
    };
  };
    
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.autoUpgrade.enable  = true;
  system.autoUpgrade.allowReboot  = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  
  security.rtkit.enable = true;

  users.users.aatricks = {
    isNormalUser = true;
    description = "Emilio Melis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      	gnome-software
      	fishPlugins.done
	    fishPlugins.fzf-fish
	    fishPlugins.forgit
	    fishPlugins.hydro
	    fzf
	    fishPlugins.grc
      zeal
      	gnome-tweaks
      	dconf-editor
      	gnome-extension-manager
      	vesktop
      	gruvbox-gtk-theme
      	blackbox-terminal
      	unstable.zed-editor
      	unstable.vscode
    ];
  };
  
  environment = {
    gnome.excludePackages = (with pkgs; [
	    atomix cheese baobab snapshot
	    simple-scan eog file-roller
	    seahorse epiphany evince geary
	    hitori iagno tali totem
	    yelp gnome-characters gnome-music 
	    gnome-photos gnome-tour
	    gnome-calculator gnome-calendar
	    gnome-clocks gnome-contacts
      gnome-font-viewer gnome-logs
      gnome-maps gnome-screenshot
      gnome-weather gnome-connections
      gnome-console gnome-system-monitor
	  ]);
    #sessionVariables = {
    #  LIBVA_DRIVER_NAME = "iHD";
    #  NIXOS_OZONE_WL = "1";
    #};
    systemPackages = with pkgs; [
      	home-manager
      	nano
      	wget
      	git
      	pciutils
      	undervolt
	    wakeonlan
	    grc
	    gcc
	    python312
	    uv
	    gh
	    cargo
	    rustc
	    rustup
	    rust-analyzer 
	    clang-tools
	    htop
	    ruff
    ];
  };

  home-manager.users.aatricks = { pkgs, ... }: {
    home.packages = [];
    programs.bash.enable = true;
    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
	      blur-my-shell.extensionUuid
	      dash-to-dock.extensionUuid
	      user-themes.extensionUuid
	      caffeine.extensionUuid
	      appindicator.extensionUuid
	      just-perfection.extensionUuid
	      open-bar.extensionUuid
	      light-style.extensionUuid
	      places-status-indicator.extensionUuid
        ];
      };
      settings."org/gnome/shell/extensions/user-theme" = {
       		name = "Gruvbox-Dark";
	    };
      settings."org/gnome/shell/extensions/dash-to-dock" = {
       		show-icons-emblems = false;
       		show-show-apps-button = false;
       		show-trash = false;
       		transparency-mode = "FIXED";
       		custom-theme-shrink = true;
	    };
      settings."com/raggesilver/BlackBox" = {
        	custom-shell-command = "/run/current-system/sw/bin/fish";
        	delay-before-showing-floating-controls = 100;
        	easy-copy-paste = true;
        	floating-controls = true;
        	floating-controls-hover-area=30;
        	font = "Source Code Pro 12";
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
      settings."org/gnome/nautilus/list-view" = {
      	  default-zoom-level = "small";
      };
      settings."org/gnome/nautilus/preferences" = {
        	default-folder-viewer = "list-view";
      };
      settings."org/gnome/shell/extensions/openbar" = {
            accent-override=false;
            apply-accent-shell=false;
            apply-all-shell=false;
            apply-flatpak=false;
            apply-gtk=false;
            apply-menu-notif=false;
            apply-menu-shell=false;
            auto-bgalpha=true;
            autofg-bar=false;
            autofg-menu=true;
            autohg-bar=true;
            autohg-menu=true;
            autotheme-dark="Dark";
            autotheme-font=false;
            autotheme-light="Pastel";
            autotheme-refresh=false;
            balpha=0.84999999999999998;
            bartype="Islands";
            bg-change=false;
            bgalpha=0.0;
            bgalpha-wmax=1.0;
            bgalpha2=0.69999999999999996;
            bgpalette=true;
            bguri=file:///home/aatricks/.config/background;
            border-wmax=true;
            bordertype="solid";
            bottom-margin=6.5;
            boxalpha=0.0;
            bradius=30.0;
            buttonbg-wmax=true;
            bwidth=0.0;
            candyalpha=0.98999999999999999;
            candybar=false;
            card-hint=10;
            color-scheme="default";
            corner-radius=false;
            count1=274666;
            count10=168;
            count11=120;
            count12=4;
            count2=231949;
            count3=92540;
            count4=41616;
            count5=12006;
            count6=6051;
            count7=4369;
            count8=2126;
            count9=385;
            cust-margin-wmax=true;
            dark-bguri=file:///home/aatricks/.config/background;
            dashdock-style="Default";
            dbgalpha=0.69999999999999996;
            dborder=true;
            dbradius=0.0;
            default-font="Sans 12";
            disize=38.0;
            dshadow=true;
            fgalpha=0.75;
            fitts-widgets=true;
            gradient=false;
            gradient-direction="vertical";
            gtk-popover=false;
            gtk-shadow="Default";
            gtk-transparency=1.0;
            halpha=0.5;
            handle-border=3.0;
            hbar-gtk3only=false;
            headerbar-hint=0;
            heffect=false;
            height=35.0;
            hpad=1.0;
            import-export=true;
            isalpha=0.0;
            margin=0.0;
            margin-wmax=0.0;
            mbalpha=0.59999999999999998;
            mbg-gradient=false;
            mbgalpha=0.90000000000000002;
            menu-radius=21.0;
            menustyle=false;
            mfgalpha=1.0;
            mhalpha=0.29999999999999999;
            monitor-height=2000;
            monitor-width=3000;
            monitors="all";
            msalpha=0.84999999999999998;
            mshalpha=0.16;
            neon=false;
            neon-wmax=true;
            notif-radius=10.0;
            pause-reload=false;
            position="Top";
            qtoggle-radius=50.0;
            radius-bottomleft=true;
            radius-bottomright=true;
            radius-topleft=true;
            radius-topright=true;
            reloadstyle=true;
            removestyle=false;
            sbar-gradient="none";
            set-bottom-margin=false;
            set-fullscreen=true;
            set-notif-position=true;
            set-notifications=false;
            set-overview=false;
            set-yarutheme=false;
            shadow=false;
            shalpha=0.20000000000000001;
            sidebar-hint=10;
            slider-height=4.0;
            smbgalpha=0.94999999999999996;
            smbgoverride=true;
            traffic-light=false;
            trigger-autotheme=true;
            trigger-reload=false;
            view-hint=0;
            vpad=4.0;
            width-bottom=true;
            width-left=true;
            width-right=true;
            width-top=true;
            winbalpha=0.75;
            winbradius=15.0;
            winbwidth=0.0;
            window-hint=0;
            wmax-hbarhint=false;
            wmaxbar=true;
      };
    };

      programs.git = {
        enable = true;
        userName  = "Aatrick";
        userEmail = "melis.emilio1@gmail.com";
      };
      home.stateVersion = "24.11";
  };
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-backup";

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [];
    firefox.enable = false;
    gamescope.enable = true;
    gamemode.enable = true;
    fish.enable = true;
    dconf.profiles.gdm.databases = [
        {
          settings."org/gnome/settings-daemon/plugins/power" = {
              ambient-enabled = true;
          };
         }
      ];
    steam = {
	    enable = true;
	    remotePlay.openFirewall = true;
	    dedicatedServer.openFirewall = true;
	    localNetworkGameTransfers.openFirewall = true;
	  };
  };
  
  hardware = {
    graphics = {
      	enable = true;
      	extraPackages = with pkgs; [
	      	intel-media-driver
	      intel-compute-runtime
	      	vpl-gpu-rt
	      	libvdpau-va-gl
	      	vaapiIntel
      	];
    };
    pulseaudio.enable = false;
  };
  
  services = {
    system76-scheduler = {
      enable = true;
      useStockConfig = true;
    };
    xserver.enable = true;
    xserver.displayManager.gdm.enable = true;
    xserver.desktopManager.gnome.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    printing.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    auto-cpufreq ={
      enable = true;
      settings = {
        battery = {
           governor = "powersave";
           turbo = "never";
        };
        charger = {
           governor = "performance";
           turbo = "auto";
        };
      };
    };
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';
  };
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
  };
  
  boot = {
    extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';
    blacklistedKernelModules =
      [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  };
  
  
  
  systemd.services.undervolt = {
    description = "Undervolt at startup";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/undervolt -v --core -100 --uncore -30 --analogio -30 --cache -100 --gpu -80 "; #-p1 5 20 -p2 10 0.01 --turbo 1 --lock-power-limit
      User = "root";
    };
  };

  systemd.timers.undervolt = {
    description = "Run undervolt service every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";  # Start 1 minute after boot
      OnUnitActiveSec = "1min";  # Run every 1 minute
      Unit = "undervolt.service";
    };
  };

  # nix run github:bayasdev/envycontrol --no-write-lock-file -- -s integrated
  system.stateVersion = "24.11";

}
