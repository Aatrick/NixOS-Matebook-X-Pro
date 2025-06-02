{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    dejavu_fonts
    freefont_ttf
    gyre-fonts # TrueType substitutes for standard PostScript fonts
    liberation_ttf
    unifont
    noto-fonts-color-emoji
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
  ];
}
