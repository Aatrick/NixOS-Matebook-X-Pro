{ pkgs, ... }:
{
  imports = [
    #../nixos/vm.nix
  ];

  home.packages = with pkgs; [
    virt-manager
  ];
}
