{ self, ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = true;
    flake = "/home/<username>/config";
    flags = [
        "--update-input"
        "nixpkgs"
        "--update-input"
        "home-manager"
        "--update-input"
        "nixos-hardware"
      ];
    rebootWindow =
    {
        lower = "02:00";
        upper = "06:00";
    };
  };

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };
}
