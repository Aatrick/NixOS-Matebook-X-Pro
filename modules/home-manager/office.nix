{ pkgs, ... }:

{
  home.packages = with pkgs; [
    texliveFull
    texstudio
    onlyoffice-bin
    thunderbird-latest-bin
  ];
}
