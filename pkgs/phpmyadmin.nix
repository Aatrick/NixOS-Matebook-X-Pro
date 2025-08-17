{ lib, pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "phpmyadmin";
  version = "5.2.2";

  src = pkgs.fetchurl {
    url = "https://files.phpmyadmin.net/phpMyAdmin/${version}/phpMyAdmin-${version}-all-languages.tar.gz";
    sha256 = "sha256-hVHIvzsWbyMtXPZLrId0cunQy48v4YWPqyT5defXZbY=";
  };

  buildInputs = [ pkgs.php ];

  installPhase = ''
    mkdir -p $out/share/phpmyadmin
    cp -r * $out/share/phpmyadmin
  '';

  meta = with lib; {
    description = "Web-based MySQL administration tool";
    homepage = "https://www.phpmyadmin.net/";
    license = licenses.gpl2Plus;
    maintainers = [ "Quentin Horgues" ];
  };
}
