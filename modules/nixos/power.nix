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
      description = "Power management tool to use (tlp, auto-cpufreq)";
      type = lib.types.enum [ "tlp" "auto-cpufreq" ];
    };
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = [
        pkgs.powertop
        pkgs-unstable.tlp
      ];
    }
    (lib.mkIf cfg.battery.enable {
      services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
      services.power-profiles-daemon.enable = false; # Disable GNOMEs power management
      services.clight.enable = true; # Enable automatic brightness adjustment
      powerManagement.powertop.enable = true; # Enable powertop auto-tune

      services.tlp = {
        enable = cfg.battery.tool == "tlp";
        settings = {
          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";

          WIFI_PWR_ON_AC = "on";
          WIFI_PWR_ON_BAT = "on";

          START_CHARGE_THRESH_BAT0 = 65;
          STOP_CHARGE_THRESH_BAT0 = 80;

          RESTORE_DEVICE_STATE_ON_STARTUP = 1;
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
