{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  vars,
  ...
}:
let
  cfg = config.custom;
in
{
  options.custom = {
    battery.enable = lib.mkOption {
      default = false;
      description = "Enable better battery support";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.battery.enable {
    services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
    services.power-profiles-daemon.enable = false; # Disable GNOMEs power management
    powerManagement.powertop.enable = true; # Enable powertop auto-tune
    services.tlp = {
      enable = true; # Enable TLP (better than gnomes internal power manager)
      settings = {
        # CPU settings
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # More aggressive than balance_power

        # GPU settings
        INTEL_GPU_MIN_FREQ_ON_AC = 300;
        INTEL_GPU_MIN_FREQ_ON_BAT = 300;
        INTEL_GPU_MAX_FREQ_ON_BAT = 450;
        INTEL_GPU_MAX_FREQ_ON_AC = 1100;
        INTEL_GPU_BOOST_FREQ_ON_BAT = 600;
        INTEL_GPU_BOOST_FREQ_ON_AC = 1100;

        # Connectivity
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        # Connectivity / PCIe
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        # Audio
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;

        # Storage
        SATA_LINKPWR_ON_AC = "max_performance";
        SATA_LINKPWR_ON_BAT = "min_power";

        # USB
        USB_AUTOSUSPEND = 1;

        # Runtime Power Management
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";

        # Battery Health (Adjust these if you need 100% charge)
        START_CHARGE_THRESH_BAT0 = 65;
        STOP_CHARGE_THRESH_BAT0 = 80;

        RESTORE_DEVICE_STATE_ON_STARTUP = 1;
        TLP_DEFAULT_MODE = "BAT";
      };
    };
  };
}
