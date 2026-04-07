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

    CPU_BOOST_ON_BAT = lib.mkForce 0;
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
    coreOffset = -80;
    gpuOffset = -80;
    uncoreOffset = -80;
    analogioOffset = 0;
    useTimer = true;
    p1.limit = 15;
    p1.window = 28;
    p2.limit = 25;
    p2.window = 0.001;
  };

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
