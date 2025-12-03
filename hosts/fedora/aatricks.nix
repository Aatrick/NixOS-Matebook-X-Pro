{ config, pkgs, ... }:

{
  imports = [
    #../../modules/home-manager/android.nix
    ../../modules/home-manager/dev.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/gnome.nix
    #../modules/home-manager/office.nix
    ../../modules/home-manager/shell.nix
    #../modules/home-manager/vm-manager.nix
    #../../modules/home-manager/zed.nix
  ];

  home.username = "aatricks";
  home.homeDirectory = "/home/aatricks";

  home.packages = with pkgs; [
    equibop
    #deskflow
  ];
  
  nixpkgs.config.allowUnfree=true;

  # Set the state version
  home.stateVersion = "25.05";
}
