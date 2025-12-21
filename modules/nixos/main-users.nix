{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.winter.main-user;
in
{
  options = {
    winter.main-user.enable = lib.mkEnableOption "enable user module";

    winter.main-user.userName = lib.mkOption {
      default = "mainuser";
      description = ''
        username
      '';
    };

    winter.main-user.userFullName = lib.mkOption {
      default = ''main user'';
      description = ''
        full username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      initialPassword = "1234";
      description = cfg.userFullName;
      extraGroups = [
        "wheel"
        "networkmanager"
        "adbusers"
      ];
      shell = pkgs.fish;
    };
    programs.fish.enable = true;
  };
}
