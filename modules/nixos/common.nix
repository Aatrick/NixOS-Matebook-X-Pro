{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings = {
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
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
  networking.firewall = {
    enable = lib.mkForce true;
    # Allows Tailscale traffic
    trustedInterfaces = [ "tailscale0" ];

    # Required for Tailscale to route correctly (UDP hole punching)
    checkReversePath = "loose";
  };
  services.tailscale.enable = true;

  console.keyMap = "us";

  programs.adb.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++
      zlib # libz
      glib # libglib
      ncurses5
      libxml2
      openssl
      freetype
      fontconfig
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
    ];
  };

  environment.systemPackages = with pkgs; [
    gvfs
    gnome-online-accounts
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
