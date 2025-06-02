{ pkgs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    ./hardware/unowhy-13.nix
    ../modules/bootloader.nix
    ../modules/common.nix
    ../modules/fonts.nix
    ../modules/firefox.nix
    ../modules/users.nix
    ../modules/sound.nix
    ../modules/desktop-gnome.nix
    ../modules/security.nix
    ../modules/zram.nix
    ../modules/update.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "defaults" ];
  services.udev.extraRules = ''
    # Unplug
    SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="0",RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"

    # Plug
    SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="1",RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
  '';
}
