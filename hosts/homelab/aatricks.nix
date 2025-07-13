{ pkgs, pkgs-unstable, ... }: {

  imports = [
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/zed.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/shell.nix
    #../../modules/home-manager/office.nix
    ../../modules/home-manager/vm-manager.nix
    #../../modules/home-manager/android.nix
  ];

  home.username = "aatricks";
  home.homeDirectory = "/home/aatricks";
  nixpkgs.config.allowUnfree = true;
  # home.enableNixpkgsRelease = false;
  home.keyboard = {
    layout = "us";
    variant = "us";
  };

  home.packages = with pkgs; [
    vesktop
    spotify

    #deskflow
  ];

  home.stateVersion = "25.05";
}
