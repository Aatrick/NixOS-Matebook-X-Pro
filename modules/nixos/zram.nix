{ lib, ... }:

{
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
    memoryPercent = lib.mkDefault 30;
    priority = 5;
  };
}
