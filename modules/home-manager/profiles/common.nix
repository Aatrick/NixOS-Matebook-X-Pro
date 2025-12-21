{pkgs, ...}: {
  imports = [
    ../gnome.nix
    ../git.nix
    ../dev.nix
    ../shell.nix
    ../flake-script.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.11";
}
