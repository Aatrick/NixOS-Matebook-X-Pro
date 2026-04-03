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
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  system.stateVersion = config.system.nixos.release;

  time.timeZone = "Europe/Paris";
  location.latitude = 48.8566;
  location.longitude = 2.3522;
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

  # networking.nameservers = [
  #   "1.1.1.1"
  #   "1.0.0.1"
  #   "2606:4700:4700::1111"
  #   "2606:4700:4700::1001"
  # ];
  # networking.networkmanager.dns = "none";
  # networking.dhcpcd.extraConfig = "nohook resolv.conf";
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

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

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
      libxkbcommon
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
      xorg.libxcb
      xorg.libXau
      xorg.libXdmcp
      libGL
      xorg.libSM
      xorg.libICE
    ];
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.systemPackages = with pkgs; [
    gvfs
    gnome-online-accounts

    # audio tools & codec libraries for better Bluetooth support
    pavucontrol
    helvum
    ldacbt
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
