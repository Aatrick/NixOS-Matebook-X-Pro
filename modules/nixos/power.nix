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
    services.auto-cpufreq.enable = true;
  };
}
