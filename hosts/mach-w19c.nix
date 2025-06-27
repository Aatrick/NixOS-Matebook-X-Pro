{ config, pkgs, ... }:
{
  imports = [
    ./hardware/mach-w19c.nix
    ../modules/bootloader.nix
    ../modules/common.nix
    ../modules/fonts.nix
    ../modules/users.nix
    ../modules/sound.nix
    ../modules/desktop-gnome.nix
    ../modules/security.nix
    ../modules/vm.nix
    ../modules/zram.nix
    ../modules/games.nix
    ../modules/ollama.nix
    ../modules/update.nix
    ../modules/postgresSQL.nix
    ../modules/android.nix
    ../modules/power.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "defaults" ];
    # environment.systemPackages = with pkgs; [
    #   gnome-randr
    # ];
    services.udev.extraRules = ''
    '';
    hardware.graphics = {
      enable = true;
	    enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        libvdpau-va-gl
        intel-compute-runtime
      ];
    };
    zramSwap.memoryPercent = 25;
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    hardware.sensor.iio.enable = true;

    nix.settings.download-buffer-size = 1024288000;

    boot.tmp.useTmpfs = false;
}
