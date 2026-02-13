{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../options.nix
    ../fonts
    ../gnome
    ../boot.nix
    ../common.nix
    ../main-users.nix
    ../sound.nix
    ../security.nix
    ../zram.nix
    ../update.nix
    ../power.nix
    ../flatpak.nix
    ../docker.nix
    ../main-user-common.nix
  ];

  winter.gnome = {
    scaling = lib.mkDefault 2;
    text-scaling = lib.mkDefault 0.8;
  };

  winter.security.hardening = lib.mkDefault true;

  services.fstrim.enable = lib.mkDefault true;

  fileSystems."/".options = [
    "noatime"
    "nodiratime"
    "discard"
    "defaults"
  ];
}
