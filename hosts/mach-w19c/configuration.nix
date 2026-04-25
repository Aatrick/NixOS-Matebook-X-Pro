{
  self,
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
let
  envycontrol = pkgs.python3Packages.buildPythonApplication {
    pname = "envycontrol";
    version = "3.5.2";
    src = inputs.envycontrol;
    pyproject = true;
    build-system = [ pkgs.python3Packages.setuptools ];
  };

  applyUndervoltPowerLimits = pkgs.writeShellScript "apply-undervolt-power-limits" ''
    set -eu

    on_ac=0

    for supply in /sys/class/power_supply/*; do
      [ -e "$supply/type" ] || continue

      if [ "$(cat "$supply/type")" = "Mains" ] \
        && [ -e "$supply/online" ] \
        && [ "$(cat "$supply/online")" = "1" ]; then
        on_ac=1
        break
      fi
    done

    if [ "$on_ac" = "1" ]; then
      # AC: normal performance
      exec ${pkgs.undervolt}/bin/undervolt \
        --power-limit-long 15 28 \
        --power-limit-short 25 2
    else
      # Battery: battery-life focused
      exec ${pkgs.undervolt}/bin/undervolt \
        --power-limit-long 6 28 \
        --power-limit-short 10 2
    fi
  '';

  applyDisplayRefreshRate = pkgs.writeShellScript "apply-display-refresh-rate" ''
    set -eu

    uid="$(${pkgs.coreutils}/bin/id -u)"
    runtime_dir="/run/user/$uid"

    [ -S "$runtime_dir/bus" ] || exit 0

    export XDG_RUNTIME_DIR="$runtime_dir"
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime_dir/bus"

    on_ac=0

    for supply in /sys/class/power_supply/*; do
      [ -e "$supply/type" ] || continue

      if [ "$(${pkgs.coreutils}/bin/cat "$supply/type")" = "Mains" ] \
        && [ -e "$supply/online" ] \
        && [ "$(${pkgs.coreutils}/bin/cat "$supply/online")" = "1" ]; then
        on_ac=1
        break
      fi
    done

    output="eDP-1"

    if [ "$on_ac" = "1" ]; then
      mode="3000x2000@59.999"
    else
      mode="3000x2000@48.009"
    fi

    exec ${pkgs.gnome-randr}/bin/gnome-randr modify \
      --mode "$mode" \
      "$output"
  '';
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/workstation.nix
    ../../modules/nixos/games.nix
    # ../../modules/nixos/vm.nix
  ];

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   # powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   #package = config.boot.kernelPackages.nvidiaPackages.beta;
  #   prime = {
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };
  #   };
  # };

  hardware.opentabletdriver.enable = true;

  custom.battery.enable = true;
  custom.battery.tool = "tlp";
  winter.security.hardening = false;

  # This MateBook does not expose ACPI platform profiles, so prefer TLP's
  # Intel pstate/EPP tuning instead of platform-profile integration.
  services.tlp.settings = {
    PLATFORM_PROFILE_ON_AC = lib.mkForce "";
    PLATFORM_PROFILE_ON_BAT = lib.mkForce "";
    PLATFORM_PROFILE_ON_SAV = lib.mkForce "";

    CPU_SCALING_GOVERNOR_ON_AC = lib.mkForce "powersave";
    CPU_SCALING_GOVERNOR_ON_BAT = lib.mkForce "powersave";
    CPU_SCALING_GOVERNOR_ON_SAV = lib.mkForce "powersave";

    CPU_ENERGY_PERF_POLICY_ON_BAT = lib.mkForce "balance_power";
    CPU_ENERGY_PERF_POLICY_ON_SAV = "power";

    CPU_BOOST_ON_BAT = lib.mkForce 1;
    CPU_BOOST_ON_SAV = 0;
    CPU_MAX_PERF_ON_SAV = 50;
  };

  services.devmon.enable = lib.mkForce false;
  services.udisks2.mountOnMedia = lib.mkForce false;
  hardware.bluetooth.powerOnBoot = lib.mkForce false;

  networking.hostName = "mach-w19c";
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;
  boot.tmp.useTmpfs = false;
  boot.kernelParams = [
    "i915.enable_psr=1"
    "i915.enable_guc=3"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
    "i915.enable_dc=2"
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  systemd.sleep.extraConfig = ''
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  zramSwap = {
    memoryPercent = 50;
    priority = lib.mkForce 20;
  };

  # Keep zram as primary swap (priority 20), use disk swap as overflow.
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
      priority = 5;
    }
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = [
    envycontrol
    pkgs.pciutils
    pkgs.gnome-randr
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit
        self
        inputs
        pkgs
        pkgs-unstable
        ;
    };
    backupFileExtension = "backup";
    users = {
      "aatricks" = import ./aatricks.nix;
    };
  };

  hardware.sensor.iio.enable = true;

  services.undervolt = {
    enable = true;
    verbose = true;

    # NixOS sets both CPU core and cache from coreOffset.
    coreOffset = -75;

    # Your YouTube 4K test suggests -100 mV is too aggressive.
    gpuOffset = -80;

    # Do not set these unless separately tested.
    # uncoreOffset = ...;
    # analogioOffset = ...;

    # Keep this if your machine resets undervolt settings.
    # Since p1/p2 are not set here, the timer will not overwrite
    # the dynamic AC/BAT power limits below.
    useTimer = true;
  };
  systemd.services.undervolt-power-limits = {
    description = "Apply Intel PL1/PL2 depending on AC or battery";
    after = [ "undervolt.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = applyUndervoltPowerLimits;
    };
  };

  systemd.services.undervolt-power-limits-resume = {
    description = "Reapply Intel PL1/PL2 after resume";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];

    unitConfig.StopWhenUnneeded = true;

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = applyUndervoltPowerLimits;
    };
  };

  systemd.services.display-refresh-rate = {
    description = "Set GNOME display refresh rate depending on AC or battery";
    after = [ "display-manager.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "aatricks";
      ExecStart = applyDisplayRefreshRate;
    };
  };

    services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${pkgs.systemd}/bin/systemctl --no-block start undervolt-power-limits.service"
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${pkgs.systemd}/bin/systemctl --no-block start display-refresh-rate.service"
  '';

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Huawei Mach Touchpad Resolution]
    MatchUdevType=touchpad
    MatchName=*SYNA1D31:00 06CB:CD48 Touchpad*
    AttrResolutionHint=50x50
  '';
}
