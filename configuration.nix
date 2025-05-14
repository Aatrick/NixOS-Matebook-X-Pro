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
      unstable.vesktop
      blackbox-terminal
      zeal
      unstable.vscode
      texliveFull
      texstudio
      foliate
      unstable.zed-editor
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
      python312 unstable.uv unstable.ruff
      steam-run
      libvirt virt-manager
      python312Packages.pygments
      nixd
      nil
      grc gcc libgcc gnumake clang-tools
      cmake extra-cmake-modules clang gdb
      stdenv.cc.cc.lib
      cargo rustc rustup rust-analyzer 
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

  programs = {
    adb.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [];
    firefox.enable = false;
    gamescope.enable = true;
    gamemode.enable = true;
    steam = {
	    enable = true;
	    remotePlay.openFirewall = true;
	    dedicatedServer.openFirewall = true;
	    localNetworkGameTransfers.openFirewall = true;
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
    ollama.enable = true;
    udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';
  };
  
  hardware.sensor.iio.enable = true;
  
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
  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
  '';
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  
  
  
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
