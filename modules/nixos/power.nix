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
      powerManagement.powertop.enable = true; # Enable powertop auto-tune
      services.tlp = {
        enable = true;
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
    })
  ];

}
