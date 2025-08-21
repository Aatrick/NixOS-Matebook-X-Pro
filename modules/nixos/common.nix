{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = config.system.nixos.release;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  networking.networkmanager.enable = lib.mkDefault true;
  networking.firewall.enable = lib.mkForce true;

  console.keyMap = "us";

  programs.nix-ld.enable = lib.mkDefault true;
  # Make common runtime libs available to foreign binaries (pip wheels, etc.)
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc  # provides libstdc++.so.6 and libgcc_s.so.1
    zlib          # common dependency for many wheels
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };
  systemd.tmpfiles.rules = [
    "d /media 0755 root root -"
  ];
}
