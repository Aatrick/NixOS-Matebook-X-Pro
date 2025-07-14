{ self, inputs, pkgs, pkgs-unstable, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ./hardware-configuration.nix
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
    # ../../modules/nixos/games.nix
    # ../../modules/nixos/vm.nix
  ];

  hardware.nvidia = {
      # modesetting.enable = true;
      # powerManagement.enable = false;
      # powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

  networking.hostName = "FMac";
  boot.tmp.useTmpfs = false;
  boot.kernelPackages = pkgs.linuxPackages;
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "defaults" ];

  winter.main-user = {
    enable = true;
    userName = "aatricks";
    userFullName = "Emilio Melis";
  };

  home-manager = {
    extraSpecialArgs = { inherit self inputs pkgs pkgs-unstable; };
    users = {
      "aatricks" = import ./aatricks.nix;
    };
  };

    zramSwap.memoryPercent = 25;
    hardware.sensor.iio.enable = true;

    services.undervolt = {
        enable = true;
        analogioOffset = -20;
        coreOffset = -105;
        uncoreOffset = -20;
        gpuOffset = -75;
        useTimer = true;
        p1.limit = 10;
        p1.window = 20;
        p2.limit = 40;
        p2.window = 0.01;
        tempBat = -40;
        tempAc = -5;
      };
}
