{ lib, ... }:
{
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
    memoryPercent = lib.mkDefault 100;
    priority = 100;
  };

  services.udev.extraRules = ''
    ACTION=="change", KERNEL=="zram0", ATTR{initstate}=="1", SYSCTL{vm.swappiness}="150", RUN+="/bin/sh -c 'echo N > /sys/module/zswap/parameters/enabled'"
  '';
}
