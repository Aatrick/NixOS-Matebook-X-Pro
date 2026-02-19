{ appimageTools, lib, fetchurl, symlinkJoin }:

let
  pname = "helium-browser";
  version = "0.9.2.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-guDBIr8NOD0GtjWznsVXlvb6llvdWHxREfDvXeP4m/w=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [
      (appimageTools.wrapType2 {
        inherit pname version src;
      })
    ];

    postBuild = ''
      mkdir -p $out/share/applications
      cp ${appimageContents}/helium.desktop $out/share/applications/helium-browser.desktop
      substituteInPlace $out/share/applications/helium-browser.desktop \
        --replace 'Exec=helium' 'Exec=helium-browser' \
        --replace 'Icon=helium' 'Icon=helium-browser'
      
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp ${appimageContents}/helium.png $out/share/icons/hicolor/512x512/apps/helium-browser.png
    '';

    meta = with lib; {
      description = "Private, fast, and honest web browser";
      homepage = "https://helium.computer/";
      license = licenses.gpl3;
      platforms = [ "x86_64-linux" ];
    };
  }

