{ lib, ... }:

{
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
    memoryPercent = 15;
    priority = 5;
  };
}
