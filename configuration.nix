# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];
   

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  system.autoUpgrade.enable  = true;
  system.autoUpgrade.allowReboot  = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
	vscode
	jetbrains.idea-ultimate
    	zeal
    	gnome-tweaks
    	dconf-editor
    	gnome-extension-manager
    	vesktop
    	gruvbox-gtk-theme
    	blackbox-terminal
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
    };
    
      programs.git = {
        enable = true;
    userName  = "Aatrick";
    userEmail = "melis.emilio1@gmail.com";
      };
      
      home.stateVersion = "25.05";
      
  };
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm-backup";

  environment.gnome.excludePackages = (with pkgs; [
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
	  gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-contacts
    gnome-font-viewer gnome-logs gnome-maps gnome-music gnome-photos gnome-screenshot
    gnome-system-monitor gnome-weather gnome-connections gnome-console
	]);

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
  ];
  
  nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab  {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
          };
        });
      });
    })
  ];
  
  nixpkgs.config.allowAliases = false;



  services.flatpak.enable = true;
  programs.steam = {
	  enable = true;
	  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

programs.fish.enable = true;

  programs.dconf.profiles.gdm.databases = [
    {
        settings."org/gnome/settings-daemon/plugins/power" = {
            ambient-enabled = true;
        };
    }
];



  hardware.graphics = {
  	enable = true;
  	extraPackages = with pkgs; [
	  	intel-media-driver
	        intel-compute-runtime
	  	vpl-gpu-rt
	  	libvdpau-va-gl
  	];
  };

  environment.sessionVariables = {
  LIBVA_DRIVER_NAME = "iHD";
  NIXOS_OZONE_WL = "1";
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
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  services.tlp = {
      enable = true;
      settings = {
      	CPU_DRIVER_OPMODE_ON_AC="passive";
      	CPU_DRIVER_OPMODE_ON_BAT="passive";
      
        CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        
        RUNTIME_PM_ON_AC="auto";
	RUNTIME_PM_ON_BAT="auto";
	
	WIFI_PWR_ON_AC="on";
	WIFI_PWR_ON_BAT="on";

        CPU_BOOST_ON_AC=1;
	CPU_BOOST_ON_BAT=0;

	CPU_HWP_DYN_BOOST_ON_AC=1;
	CPU_HWP_DYN_BOOST_ON_BAT=0;
	
	PLATFORM_PROFILE_ON_AC="balanced";
	PLATFORM_PROFILE_ON_BAT="low-power";

        #CPU_MIN_PERF_ON_AC = 0;
        #CPU_MAX_PERF_ON_AC = 100;
        #CPU_MIN_PERF_ON_BAT = 0;
        #CPU_MAX_PERF_ON_BAT = 50;

        #CPU_SCALING_MIN_FREQ_ON_AC=400000;
	#CPU_SCALING_MAX_FREQ_ON_AC=2800000;
	#CPU_SCALING_MIN_FREQ_ON_BAT=400000;
	#CPU_SCALING_MAX_FREQ_ON_BAT=1600000;

        #INTEL_GPU_MIN_FREQ_ON_AC=300;
	#INTEL_GPU_MIN_FREQ_ON_BAT=300;
	#INTEL_GPU_MAX_FREQ_ON_AC=1100;
	#INTEL_GPU_MAX_FREQ_ON_BAT=600;
	#INTEL_GPU_BOOST_FREQ_ON_AC=1300;
	#INTEL_GPU_BOOST_FREQ_ON_BAT=600;
	
	RESTORE_DEVICE_STATE_ON_STARTUP=1;

	NMI_WATCHDOG=0;
	
	NATACPI_ENABLE=1;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # nix run github:bayasdev/envycontrol --no-write-lock-file -- -s integrated

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
