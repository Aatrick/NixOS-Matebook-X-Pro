{ pkgs, pkgs-unstable, ... }: {

  imports = [
    ../../modules/home-manager/gnome.nix
    #../../modules/home-manager/zed.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/shell.nix
    ../../modules/home-manager/flake-script.nix
    #../../modules/home-manager/office.nix
    #../../modules/home-manager/vm-manager.nix
    #../../modules/home-manager/android.nix
  ];

  winter = {
    update = {
        flake_path = "/home/aatricks/config";
        flake_config = "mach-w19c";
    };
    auto-update.enable = true;
  };

  home.username = "aatricks";
  home.homeDirectory = "/home/aatricks";
  nixpkgs.config.allowUnfree = true;
  # home.enableNixpkgsRelease = false;
  home.keyboard = {
    layout = "us";
    variant = "us";
  };

  home.packages = with pkgs; [
    foliate

    vesktop

    spotify
    media-downloader
    vlc
    #deskflow
  ];

  home.stateVersion = "25.05";
}
