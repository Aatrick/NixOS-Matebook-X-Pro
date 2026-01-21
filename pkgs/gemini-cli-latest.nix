{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  pname = "gemini-cli";
  version = "0.24.5";

  src = pkgs.fetchurl {
    url = "https://github.com/google-gemini/gemini-cli/releases/download/v${version}/gemini.js";
    hash = "sha256-e5IoWvJpI0fSgUauN0ysWyyV1PQOQVy6K/KOTEAqC1I=";
  };

  dontUnpack = true;

  buildInputs = [pkgs.nodejs];

  installPhase = ''
    mkdir -p $out/bin $out/share/gemini

    # Rename to .mjs so Node.js explicitly treats it as an ES Module
    cp $src $out/share/gemini/gemini.mjs

    # Create a shell wrapper instead of a JS wrapper
    echo "#!${pkgs.runtimeShell}" > $out/bin/gemini
    echo "exec ${pkgs.nodejs}/bin/node $out/share/gemini/gemini.mjs \"\$@\"" >> $out/bin/gemini

    chmod +x $out/bin/gemini
  '';

  meta = with pkgs.lib; {
    description = "Gemini CLI (Latest Manual Update)";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.all;
  };
}
