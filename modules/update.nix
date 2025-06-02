{ ... }:

{
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.rebootWindow =
  {
      lower = "02:00";
      upper = "06:00";
  };

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 5d";
  nix.settings.auto-optimise-store = true;
}
