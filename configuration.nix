{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
  unstableTarball = builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
    
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" ];
    packages = with pkgs; [
      fishPlugins.done fishPlugins.fzf-fish
	    fishPlugins.forgit fishPlugins.hydro
	    fishPlugins.grc fzf
      gnome-tweaks dconf-editor
      gnome-extension-manager
      gruvbox-gtk-theme
      vesktop
      blackbox-terminal
      zeal
      unstable.vscode
      zed-editor
    ];
  };
  
  environment = {
    gnome.excludePackages = (with pkgs; [
	    atomix cheese baobab snapshot
	    simple-scan eog file-roller
	    seahorse epiphany evince geary
	    hitori iagno tali totem
	    yelp gnome-characters gnome-music 
	    gnome-photos gnome-tour gnome-software
	    gnome-calculator gnome-calendar
	    gnome-clocks gnome-contacts
      gnome-font-viewer gnome-logs
      gnome-maps gnome-screenshot
      gnome-weather gnome-connections
      gnome-console gnome-system-monitor
	  ]);
	  sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
    systemPackages = with pkgs; [
      home-manager nano git wget gh htop
	    grc gcc libgcc gnumake clang-tools
      cmake extra-cmake-modules
      stdenv.cc.cc.lib
	    python312 uv ruff
	    cargo rustc rustup rust-analyzer 
	    steam-run # for launching single executable
	    libvirt virt-manager
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
	        light-style.extensionUuid
	        places-status-indicator.extensionUuid
        ];
      };
      settings."org/gnome/shell/extensions/user-theme" = {
       		name = "Gruvbox-Dark";
	    };
	    #settings."/org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
	    #  blur = false;
	    #};
	    #settings."/org/gnome/shell/extensions/blur-my-shell/panel" = {
	    #  blur = true;
	    #  brightness = 0.6;
	    #  override-background = true;
	    #  override-background-dynamically = true;
	    #  sigma = 0;
	    #  static-blur = false;
	    #  style-panel = 0;
	    #  unblur-in-overview = true;
	    #};
	    #settings."/org/gnome/shell/extensions/blur-my-shell" = {
	    #  hack-level = 0;
	    #};
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
    };
    programs.git = {
      enable = true;
      userName  = "Aatrick";
      userEmail = "melis.emilio1@gmail.com";
    };
    home.stateVersion = "24.11";
  };
  home-manager.useUserPackages = true;

  programs = {
    adb.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [];
    firefox.enable = false;
    gamescope.enable = true;
    gamemode.enable = true;
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
    steam = {
	    enable = true;
	    remotePlay.openFirewall = true;
	    dedicatedServer.openFirewall = true;
	    localNetworkGameTransfers.openFirewall = true;
	  };
  };
  
  services = {
    xserver.enable = true;
    xserver.displayManager.gdm.enable = true;
    xserver.desktopManager.gnome.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    xserver.excludePackages = with pkgs; [
      xterm
    ];
    printing.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        CPU_BOOST_ON_AC=1;
        CPU_BOOST_ON_BAT=0;
        CPU_HWP_DYN_BOOST_ON_AC=1;
        CPU_HWP_DYN_BOOST_ON_BAT=0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 50;
        RESTORE_DEVICE_STATE_ON_STARTUP=1;
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    undervolt = {
      enable = true;
      analogioOffset = -30;
      coreOffset = -90;
      uncoreOffset = -30;
      gpuOffset = -80;
      useTimer = true;
    };
    ollama.enable = true;
  };
  
  hardware.sensor.iio.enable = true;
  
  hardware.graphics = {
  	enable = true;
  	extraPackages = with pkgs; [
	  	intel-media-driver
	  	vpl-gpu-rt
	  	libvdpau-va-gl
	  	intel-compute-runtime
  	];
  };
 
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
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
  
  # VM
  security.apparmor.enable = false;
  programs.virt-manager.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
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
  
  # nix run github:bayasdev/envycontrol --no-write-lock-file -- -s integrated
  # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # flatpak install flathub app.zen_browser.zen
  
  system.stateVersion = config.system.nixos.release;

}
