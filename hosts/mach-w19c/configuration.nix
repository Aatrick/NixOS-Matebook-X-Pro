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
    ../../modules/options.nix
    ../../modules/nixos/fonts
    ../../modules/nixos/gnome
    ../../modules/nixos/boot.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/main-users.nix
    ../../modules/nixos/sound.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/zram.nix
    ../../modules/nixos/update.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/flatpak.nix
    #../../modules/nixos/games.nix
    # ../../modules/nixos/vm.nix
    ../../modules/nixos/docker.nix
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

  environment.variables = {
    ZED_MAX_FPS = "60";
  };

  networking.hostName = "FMac";
  boot.tmp.useTmpfs = false;
  boot.kernelPackages = pkgs.linuxPackages;
  fileSystems."/".options = [
    "noatime"
    "nodiratime"
    "discard"
    "defaults"
  ];

  winter = {
    main-user = {
      enable = true;
      userName = "aatricks";
      userFullName = "Emilio Melis";
    };
    gnome = {
      scaling = 2;
      text-scaling = 0.8;
    };
    # vm = {
    #     users = [ "aatricks" ];
    # };
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

  zramSwap.memoryPercent = 25;
  hardware.sensor.iio.enable = true;

  services.undervolt = {
    enable = true;
    coreOffset = -110;
    gpuOffset = -100;
    useTimer = true;
    p1.limit = 7;
    p1.window = 10;
    p2.limit = 15;
    p2.window = 0.01;
  };
}
