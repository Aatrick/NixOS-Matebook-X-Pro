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
    battery.tool = lib.mkOption {
      default = "auto-cpufreq";
      description = "Power management tool to use (tlp, auto-cpufreq, power-profiles-daemon)";
      type = lib.types.enum [ "tlp" "auto-cpufreq" "power-profiles-daemon" ];
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.battery.enable && cfg.battery.tool == "auto-cpufreq") {
      environment.systemPackages = [
        pkgs-unstable.auto-cpufreq
      ];
    })
    (lib.mkIf cfg.battery.enable {
      services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
      services.power-profiles-daemon.enable = cfg.battery.tool == "power-profiles-daemon";

      services.tlp = {
        enable = cfg.battery.tool == "tlp";
        settings = {
          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";

          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "on";

          WOL_DISABLE = "Y";

          USB_AUTOSUSPEND = 1;
          USB_EXCLUDE_BTUSB = 1;

          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 1;

          PLATFORM_PROFILE_ON_AC = "balanced";
          PLATFORM_PROFILE_ON_BAT = "low-power";

          START_CHARGE_THRESH_BAT0 = 65;
          STOP_CHARGE_THRESH_BAT0 = 80;

          RESTORE_DEVICE_STATE_ON_STARTUP = 0;
        };
      };

      services.auto-cpufreq = {
        enable = cfg.battery.tool == "auto-cpufreq";
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };
    })
  ];

}
