{pkgs, ...}: let
  cooper-black = import ./cooper-black.nix {inherit pkgs;};
in {
  fonts.packages = with pkgs; [
    cooper-black
    dejavu_fonts
    freefont_ttf
    gyre-fonts # TrueType substitutes for standard PostScript fonts
    liberation_ttf
    unifont
    noto-fonts-color-emoji
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.monaspace
  ];
}
