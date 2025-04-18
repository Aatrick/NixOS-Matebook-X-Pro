{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
  nixos-hardware = builtins.fetchTarball https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${nixos-hardware}/huawei/machc-wa")
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
      unstable.vscode
      unstable.android-studio
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
      home-manager
      nano
      wget
      git
      pciutils
	    wakeonlan
	    grc
	    gcc
      libgcc
      gnumake
      cmake
      extra-cmake-modules
      stdenv.cc.cc.lib
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
	    steam-run # for launching single executable
	    libvirt
	    virt-manager
	    util-linux
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
  system.stateVersion = config.system.nixos.release;

}
