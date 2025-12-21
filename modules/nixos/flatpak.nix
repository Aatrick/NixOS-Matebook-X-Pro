{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];
}
