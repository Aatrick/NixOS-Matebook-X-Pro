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
        CPU_SCALING_MIN_FREQ_ON_AC=400000;
        CPU_SCALING_MAX_FREQ_ON_AC=2100000;
        CPU_SCALING_MIN_FREQ_ON_BAT=400000;
        CPU_SCALING_MAX_FREQ_ON_BAT=2700000;
        INTEL_GPU_MIN_FREQ_ON_AC=300;
        INTEL_GPU_MIN_FREQ_ON_BAT=300;
        INTEL_GPU_MAX_FREQ_ON_AC=1100;
        INTEL_GPU_MAX_FREQ_ON_BAT=450;
        INTEL_GPU_BOOST_FREQ_ON_AC=1300;
        INTEL_GPU_BOOST_FREQ_ON_BAT=450;
        PCIE_ASPM_ON_BAT="powersupersave";
        USB_AUTOSUSPEND=1;
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        RESTORE_DEVICE_STATE_ON_STARTUP=1;
        START_CHARGE_THRESH_BAT0 = 65;
        STOP_CHARGE_THRESH_BAT0 = 80;
        TLP_DEFAULT_MODE = "BAT";
      };
    };
  };
}
