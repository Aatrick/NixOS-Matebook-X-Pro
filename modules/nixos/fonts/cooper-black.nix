{ pkgs, ... }:

let
  pname = "cooper-black";
  version = "1.0";
in
pkgs.stdenv.mkDerivation {
  src = pkgs.fetchurl {
      url = "https://media.fontsgeek.com/download/zip/c/o/cooper-black-regular_BPDNV.zip";
      sha256 = "sha256-FSfVtagAVO7sBlitDpw8rxncol4kTGOX9qFIJxFNSKw=";
  };
  name = ''${pname}-${version}'';
  buildInputs = [ pkgs.unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    unzip $src -d extracted
    find extracted/Cooper\ Black\ Regular/ -iname "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
  '';
  meta = with pkgs.lib; {
      description = "Cooper Black font";
      homepage = "https://fontsgeek.com/fonts/Cooper-Black-Regular";
      license = licenses.unfreeRedistributable;
      platforms = platforms.all;
  };
}
