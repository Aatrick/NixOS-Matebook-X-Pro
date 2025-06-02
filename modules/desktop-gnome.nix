{ pkgs, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  programs.dconf.profiles.gdm.databases = [{
    settings = {
        "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
            remember-numlock-state = true;
        };
        "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
        };
        "org/gnome/desktop/interface" = {
            scaling-factor = lib.gvariant.mkUint32 2;
            show-battery-percentage = true;
            text-scaling-factor = 0.9;
        };
    };
  }];

  environment.gnome.excludePackages = with pkgs; [
    atomix # puzzle game
    cheese # webcam tool
    baobab
    snapshot
    simple-scan
    eog
    file-roller
    seahorse
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gnome-characters
    gnome-music
    gnome-photos
    gnome-tour
    hitori # sudoku game
    iagno # go game
    tali # poker game
    totem # video player
    yelp
    gnome-calculator
    gnome-calendar
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-screenshot
    gnome-system-monitor
    gnome-weather
    gnome-connections
    gnomeExtensions.auto-move-windows
    gnome-software
    gnome-disk-utility
    gnome-console
    gnome-text-editor
    nautilus
    decibels
    loupe
    cups
  ];
}
