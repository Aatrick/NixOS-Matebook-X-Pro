{ pkgs, pkgs-unstable, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    wrapperConfig.pipewireSupport = true;
    languagePacks = [
    "fr"
    "en-US"
    ];
    preferences = {
      "intl.accept_languages" = "fr-fr,en-us,en";
      "intl.locale.requested" = "fr,en-US";
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    nativeMessagingHosts.packages = [ pkgs-unstable.firefoxpwa ];
  };
}
