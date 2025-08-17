{ pkgs, pkgs-unstable, config, lib, vars, ... }:
let
  cfg = config.custom;
  hasBattery =
    lib.any (x: lib.strings.hasPrefix "BAT" x)
    (builtins.attrNames (builtins.readDir "/sys/class/power_supply"));
in {
  options.custom = {
    battery.enable = lib.mkOption {
      default = hasBattery;
      description = "Enable better battery support";
      type = lib.types.bool;
    };
  };



  config = lib.mkIf cfg.battery.enable {
    environment.systemPackages = with pkgs; [
      powertop
    ];

    powerManagement.powertop.enable = true;

    services.system76-scheduler.settings.cfsProfiles.enable = true; # Better scheduling for CPU cycles - thanks System76!!!
    services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
    services.power-profiles-daemon.enable = false; # Disable GNOMEs power management
    services.tlp = {
      enable = true; # Enable TLP (better than gnomes internal power manager)
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        WIFI_PWR_ON_AC="on";
        WIFI_PWR_ON_BAT="on";
        CPU_BOOST_ON_AC=1;
        CPU_BOOST_ON_BAT=0;
        CPU_HWP_DYN_BOOST_ON_AC=1;
        CPU_HWP_DYN_BOOST_ON_BAT=0;
        CPU_MAX_PERF_ON_AC=100;
        CPU_MAX_PERF_ON_BAT=35;
        CPU_MIN_PERF_ON_BAT=5;
        CPU_MIN_PERF_ON_AC=5;
        PCIE_ASPM_ON_BAT="powersupersave";
        USB_AUTOSUSPEND=1;
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        RESTORE_DEVICE_STATE_ON_STARTUP=1;
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 81;
        TLP_DEFAULT_MODE = "BAT";
      };
    };
  };
}
