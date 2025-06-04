{ lib, ... }:

{
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
    memoryPercent = lib.mkDefault 15;
    priority = 5;
  };
}
