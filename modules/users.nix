{ pkgs, ... }:

{
  users.users.aatricks = {
    isNormalUser = true;
    description = "Emilio Melis";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" ];
    shell = pkgs.fish;

  };
  programs.fish.enable = true;
  services.flatpak.enable = true;
}
