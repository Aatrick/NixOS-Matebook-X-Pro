{ pkgs, ... }:

let
  cooper-black = import ./cooper-black.nix { inherit pkgs; };


  winter-use-system-font = pkgs.writeShellScriptBin "winter-use-system-font" ''
    mkdir -p ~/.local/share/fonts
    for dir in /nix/store/*/share/fonts/*; do
      [ -d "$dir" ] || continue
      cp -r $dir/* ~/.local/share/fonts/ 1>/dev/null 2>/dev/null
    done
    chmod 644 ~/.local/share/fonts/* 1>/dev/null 2>/dev/null
  '';
in
{
  environment.systemPackages = [
    winter-use-system-font
  ];
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
  ];
}
