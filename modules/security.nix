{ lib, ... }:

{
  security.rtkit.enable = lib.mkDefault true;
  security.apparmor.enable = lib.mkDefault false;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
