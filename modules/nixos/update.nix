{
  lib,
  config,
  ...
}: {
  #options.winter.auto-upgrade.enable = lib.mkOption {
  #  description = "Enable auto upgrade";
  #  type = lib.types.bool;
  #  default = false;
  #};

  #config = lib.mkIf config.winter.auto-upgrade.enable {
  # system.autoUpgrade = {
  #     enable = true;
  #     dates = "weekly";
  #     allowReboot = true;
  #     flake = "";
  #     flags = [];
  #     rebootWindow =
  #     {
  #         lower = "02:00";
  #         upper = "06:00";
  #     };
  # };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = true;
    flake = config.winter.system.flakePath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "home-manager"
      "--update-input"
      "nixos-hardware"
    ];
    rebootWindow = {
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
  services.fwupd.enable = true;
}
