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
    { environment.systemPackages = [ pkgs.powertop ]; }
    (lib.mkIf cfg.battery.enable {
      services.thermald.enable = true; # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
      services.power-profiles-daemon.enable = false; # Disable GNOMEs power management
      powerManagement.powertop.enable = true; # Enable powertop auto-tune
      services.auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "false";
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
