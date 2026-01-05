{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
    remotes = lib.mkDefault [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "helium";
        location = "https://shyvortex.github.io/helium-flatpak/";
        args = "--no-gpg-verify";
      }
    ];

    packages = [
      "app.zen_browser.zen"
      {
        appId = "com.imputnet.Helium";
        origin = "helium";
      }
    ];
  };
}
