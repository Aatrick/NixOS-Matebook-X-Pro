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
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
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
    # powerManagement.enable = false;
    # powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    #package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.opentabletdriver.enable = true;

  custom.battery.enable = true;

  networking.hostName = "mach-w19c";
  boot.tmp.useTmpfs = false;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

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
    gpuOffset = -115;
    uncoreOffset = -115;
    analogioOffset = -115;
    useTimer = true;
    p1.limit = 6;
    p1.window = 10;
    p2.limit = 6;
    p2.window = 0.01;
  };
}
