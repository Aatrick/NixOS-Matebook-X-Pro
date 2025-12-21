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
  ];
}
