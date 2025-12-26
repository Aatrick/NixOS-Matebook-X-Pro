{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.winter.update;

  nix-latest-update = import ../../pkgs/nix-latest-update.nix {
    pkgs = pkgs;
  };

  update-gemini = import ../../pkgs/update-gemini.nix {
    pkgs = pkgs;
  };

  flake-update = import ../../pkgs/flake-update.nix {
    pkgs = pkgs;
    nix-latest-update = nix-latest-update;
    update-gemini = update-gemini;
    flake_path = cfg.flake_path;
    flake_config = cfg.flake_config;
  };

  nix-clean-boot = import ../../pkgs/nix-clean-boot.nix {
    pkgs = pkgs;
    flake_path = cfg.flake_path;
    flake_config = cfg.flake_config;
  };

  nix-clean = import ../../pkgs/nix-clean.nix {
    pkgs = pkgs;
  };
in {
  options.winter = {
    update = {
      flake_path = lib.mkOption {
        type = lib.types.str;
        default = "/etc/nixos/flake.nix";
        description = "Flake config path";
      };

      flake_config = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "Flake config name";
      };
    };
  };
  config = lib.mkMerge [
    {
      home.packages = [
        flake-update
        update-gemini
        nix-clean-boot
        nix-clean
        nix-latest-update
      ];
    }
  ];
}
