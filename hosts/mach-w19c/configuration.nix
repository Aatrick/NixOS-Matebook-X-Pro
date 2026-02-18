{
  self,
  inputs,
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{
  imports = [
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.huawei-machc-wa
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/workstation.nix
    #../../modules/nixos/games.nix
    # ../../modules/nixos/vm.nix
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  hardware.opentabletdriver.enable = true;

  custom.battery.enable = true;

  networking.hostName = "mach-w19c";
  boot.tmp.useTmpfs = false;
  boot.kernelParams = [
    "i915.enable_psr=1"
    "i915.enable_guc=3"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
    "i915.enable_dc=2"
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

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
    coreOffset = -110;
    gpuOffset = -110;
    uncoreOffset = -110;
    analogioOffset = -110;
    useTimer = true;
    p1.limit = 15;
    p1.window = 10;
    p2.limit = 25;
    p2.window = 0.01;
  };
}
