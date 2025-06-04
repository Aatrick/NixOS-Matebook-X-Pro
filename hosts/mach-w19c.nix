{ config, pkgs, ... }:
{
  imports = [
    ./hardware/mach-w19c.nix
    ../modules/bootloader.nix
    ../modules/common.nix
    ../modules/fonts.nix
    ../modules/users.nix
    ../modules/sound.nix
    ../modules/desktop-gnome.nix
    ../modules/security.nix
    ../modules/vm.nix
    ../modules/zram.nix
    ../modules/games.nix
    ../modules/ollama.nix
    ../modules/update.nix
    ../modules/postgresSQL.nix
    ../modules/android.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "defaults" ];
    # environment.systemPackages = with pkgs; [
    #   gnome-randr
    # ];
    services.udev.extraRules = ''
    '';
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
    zramSwap.memoryPercent = 25;
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
    nix.settings.download-buffer-size = 1024288000;

    services = {
      flatpak.enable = true;
      power-profiles-daemon.enable = false;
      #thermald.enable = true;
      tlp = {
        enable = true;
        settings = {
          CPU_DRIVER_OPMODE_ON_AC="passive";
          CPU_DRIVER_OPMODE_ON_BAT="passive";
          CPU_SCALING_GOVERNOR_ON_AC="schedutil";
          CPU_SCALING_GOVERNOR_ON_BAT="schedutil";
          CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT="power";
          PLATFORM_PROFILE_ON_AC="balanced";
          PLATFORM_PROFILE_ON_BAT="low-power";
          CPU_BOOST_ON_AC=1;
          CPU_BOOST_ON_BAT=0;
          CPU_HWP_DYN_BOOST_ON_AC=1;
          CPU_HWP_DYN_BOOST_ON_BAT=0;
          WIFI_PWR_ON_AC="on";
          WIFI_PWR_ON_BAT="on";
          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 70;
          INTEL_GPU_MIN_FREQ_ON_AC=300;
	        INTEL_GPU_MIN_FREQ_ON_BAT=100;
	        INTEL_GPU_MAX_FREQ_ON_AC=1100;
	        INTEL_GPU_MAX_FREQ_ON_BAT=500;
	        INTEL_GPU_BOOST_FREQ_ON_AC=1300;
	        INTEL_GPU_BOOST_FREQ_ON_BAT=500;
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

    boot.tmp.useTmpfs = false;

    /*
    RUN+="${pkgs.lib.getExe (pkgs.writeShellScriptBin "powersave"
    ''
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
      ${pkgs.su}/bin/su - quentin -c "${pkgs.dbus}/bin/dbus-launch `${pkgs.gnome-randr}/bin/gnome-randr modify 'eDP-1' --mode 2560x1600@60.002`"
    '')}"

    "${pkgs.lib.getExe (pkgs.writeShellScriptBin "performance"
    ''
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
      ${pkgs.su}/bin/su - quentin -c "${pkgs.dbus}/bin/dbus-launch `${pkgs.gnome-randr}/bin/gnome-randr modify 'eDP-1' --mode 2560x1600@165.000`"
    '')}"
    */
}
