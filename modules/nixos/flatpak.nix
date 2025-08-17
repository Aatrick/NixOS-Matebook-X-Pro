{ pkgs, ... }:
{
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      # Install or update Microsoft Edge from Flathub non-interactively
      flatpak install -y --noninteractive --or-update flathub com.microsoft.Edge
    '';
  };
}
