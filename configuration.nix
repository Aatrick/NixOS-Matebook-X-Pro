{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  unstableTarball = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "FMac-Aatricks";
  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader= {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  # Set your time zone.
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
  

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    excludePackages = with pkgs; [
      xterm
    ];
    desktopManager.gnome.enable = true;
  };

  # VM
  security.apparmor.enable = false;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs = {
    adb.enable = true;
    firefox.enable = false;
    dconf.profiles.gdm.databases = [{
      settings = {
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
        };
        "org/gnome/desktop/interface" = {
          show-battery-percentage = true;
          text-scaling-factor = 0.9;
        };
      };
    }];
    
    fish.enable = true;

    nix-ld.enable = true;

    # Games
    gamescope.enable = true;
    gamemode.enable = true;
    steam = {
      gamescopeSession.enable = true;
      enable = true;
      extest.enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        unstable.proton-ge-bin
      ];
    };
  };
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    LIBVA_DRIVER_NAME = "iHD";
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.aatricks = {
    isNormalUser = true;
    description = "Emilio Melis";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" ];
    shell = pkgs.fish;


    packages = with pkgs; [
      # Gnome extension
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine

      # VM
      libvirt
      virt-manager

      # Dev
      unstable.zed-editor
      #unstable.vscode
      zeal
      blackbox-terminal

      # Nix
      nixd # Nix language server for zeditor
      nil

      # C / C++
      gcc
      clang-tools
      clang
      cmake
      gnumake

      # Rust
      cargo
      rustc
      rustup
      rust-analyzer

      # Python
      python312
      uv
      ruff

      # Games
      adwsteamgtk
      vesktop

      # Latex
      texstudio
      texliveFull
      python312Packages.pygments
      
      foliate
      
    ];
  };
  home-manager.users.aatricks = { pkgs, lib, ... }: {
    # Pointer settings for VM
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
    home.packages = [];

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
        "org/gnome/nautilus/list-view" = {
        	  default-zoom-level = "small";
        };
        "org/gnome/nautilus/preferences" = {
          	default-folder-viewer = "list-view";
        };
      };
    };

    programs = {
      git = {
        enable = true;
        userName  = "Aatrick";
        userEmail = "melis.emilio1@gmail.com";
      };
	    fish = {
        enable = true;
        shellAliases = {
          ll = "ls -l";
          update = "sudo nix-channel --update
                    sudo nix-env -u --always
                    sudo nixos-rebuild boot --upgrade-all
                    flatpak update";
          cleanup = "sudo rm /nix/var/nix/gcroots/auto/*
                     sudo nix-store --gc
                     sudo nix-collect-garbage -d";
        };
      };
    };
    home.stateVersion = config.system.nixos.release;
  };

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
    gnome-weather
    gnome-connections
    gnomeExtensions.auto-move-windows
    gnome-software
    gnome-disk-utility
    gnome-console
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  /* services.ollama = {
      enable = true;
      acceleration = "rocm";
      # Optional: preload models, see https://ollama.com/library
      loadModels = [ "llama3.2:3b" ];
    };
  services.open-webui.enable = true;*/

  environment.systemPackages = with pkgs; [
    home-manager
    
    #fish
    grc
    fish
    fishPlugins.done 
    fishPlugins.fzf-fish
	  fishPlugins.forgit 
	  fishPlugins.hydro
	  fishPlugins.grc 
	  fzf
    
    stdenv.cc.cc.lib

    # Tools
    git
    fastfetch
    htop
    gh
    nano
    gnome-tweaks
    dconf-editor
    gnome-extension-manager
    steam-run # For launch single executable (no connection with valve)
    # ollama
    # open-webui
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
    priority = 5;
  };
  
  
  services = {
    flatpak.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_DRIVER_OPMODE_ON_AC="passive";
        CPU_DRIVER_OPMODE_ON_BAT="passive";
        CPU_SCALING_GOVERNOR_ON_AC="schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT="schedutil";
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        RESTORE_DEVICE_STATE_ON_STARTUP=1;
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    undervolt = {
      enable = true;
      #analogioOffset = -30;
      coreOffset = -80;
      #uncoreOffset = -30;
      gpuOffset = -70;
      useTimer = true;
    };
  };
  
  hardware.graphics = {
    	enable = true;
	  enable32Bit = true;
    	extraPackages = with pkgs; [
	    	intel-media-driver
	    	vpl-gpu-rt
	    	libvdpau-va-gl
	    	intel-compute-runtime
    ];
  };
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
		  intelBusId = "PCI:0:2:0";
		  nvidiaBusId = "PCI:1:0:0";
	  };
  };
  
  # nix run github:bayasdev/envycontrol --no-write-lock-file -- -s integrated
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # flatpak install flathub app.zen_browser.zen

  
  system.stateVersion = config.system.nixos.release;
}
