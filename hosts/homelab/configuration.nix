{
  self,
  inputs,
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/workstation.nix
    ../../modules/nixos/nvidia-standby-fix.nix
    ../../modules/nixos/games.nix
    # ../../modules/nixos/vm.nix
    #../../modules/nixos/ollama.nix
    ../../modules/nixos/wooting.nix
    ../../modules/nixos/cuda.nix
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    # powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  networking.hostName = "Homelab";
  boot.tmp.useTmpfs = true;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  fileSystems."/".options = ["noatime" "nodiratime" "discard" "defaults"];

  winter = {
    nvidia.standby = {
      enable = true;
      old-gpu = false;
    };
    #ollama.acceleration = "cuda";
    main-user = {
      enable = true;
      userName = "aatricks";
      userFullName = "Emilio Melis";
    };
    gnome = {
      scaling = 2;
      text-scaling = 0.8;
    };
    wooting = {
      enable = true;
    };
    # vm = {
    #     users = [ "aatricks" ];
    # };
  };

  home-manager = {
    extraSpecialArgs = {inherit self inputs pkgs pkgs-unstable;};
    users = {
      "aatricks" = import ./aatricks.nix;
    };
  };

  zramSwap.memoryPercent = 25;
}
