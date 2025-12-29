{
  pkgs,
  pkgs-unstable,
  osConfig,
  ...
}:
{
  imports = [
    ../../modules/home-manager/profiles/common.nix
    # ../../modules/home-manager/zed.nix
    #../../modules/home-manager/office.nix
    #../../modules/home-manager/vm-manager.nix
    ../../modules/home-manager/android.nix
  ];

  winter = {
    update = {
      flake_path = "/home/aatricks/config";
      flake_config = "mach-w19c";
    };
  };

  home.username = "aatricks";
  home.homeDirectory = "/home/aatricks";
  # home.enableNixpkgsRelease = false;
  home.keyboard = {
    layout = "us";
    variant = "us";
  };

  home.packages = with pkgs; [
    discord
    #deskflow
  ];
}
