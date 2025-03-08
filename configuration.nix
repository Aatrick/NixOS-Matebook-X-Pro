# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    #  thunderbird
    ];
  };
  
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
    gnome-system-monitor gnome-weather gnome-disk-utility pkgs.gnome-connections
	]);

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	nano
  	wget
  	git
  	google-chrome
  	vscode
  	legcord
  	pciutils
  	htop
  	undervolt
  	gnome-software
  	fishPlugins.done
	fishPlugins.fzf-fish
	fishPlugins.forgit
	fishPlugins.hydro
	fzf
	fishPlugins.grc
	grc
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];
  
  services.flatpak.enable = true;

programs.fish.enable = true;
  
  
  hardware.graphics = {
  	enable = true;
  	extraPackages = with pkgs; [ 
	  	vaapiIntel 
	  	intel-media-driver
	        intel-compute-runtime
	  	vpl-gpu-rt
  	];
  };
  
  environment.sessionVariables = {
  LIBVA_DRIVER_NAME = "iHD";
  NIXOS_OZONE_WL = "1";
};
  
  systemd.services.pscript = {
  	description = "Run pscript.sh at startup";
  	after = [ "network.target" ];
  	wantedBy = [ "multi-user.target" ];
  	serviceConfig = {
  	  Type = "oneshot";
  	  ExecStart = "/run/current-system/sw/bin/bash /root/pscript.sh";
  	  User = "root";
  	};
  };
  
  systemd.services.undervolt = {
  description = "Undervolt at startup";
  after = [ "network.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "/run/current-system/sw/bin/undervolt -v --core -100 --uncore -30 --analogio -30 --cache -100 --gpu -80 -p1 5 20 -p2 10 0.01 --turbo 1 --lock-power-limit";
    User = "root";
  };
};

  systemd.timers.undervolt = {
  description = "Run undervolt service every 5 minutes";
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnBootSec = "1min";  # Start 1 minute after boot
    OnUnitActiveSec = "5min";  # Run every 5 minutes
    Unit = "undervolt.service";
  };
};


  
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
  
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        
        CPU_BOOST_ON_AC=1;
	CPU_BOOST_ON_BAT=0;

	CPU_HWP_DYN_BOOST_ON_AC=1;
	CPU_HWP_DYN_BOOST_ON_BAT=0;

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 30;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
