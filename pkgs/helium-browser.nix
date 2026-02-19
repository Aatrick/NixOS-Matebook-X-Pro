{ appimageTools, lib, fetchurl, symlinkJoin, buildFHSEnv, runCommand, writeScript, widevine-cdm }:

let
  pname = "helium-browser";
  version = "0.9.2.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-guDBIr8NOD0GtjWznsVXlvb6llvdWHxREfDvXeP4m/w=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  # Create a directory with AppImage contents + Widevine symlink
  heliumRoot = runCommand "helium-root" {} ''
    mkdir -p $out
    cp -r ${appimageContents}/* $out/
    chmod -R +w $out
    
    # Create the WidevineCdm directory symlink next to the binary
    mkdir -p $out/opt/helium/WidevineCdm
    ln -s ${widevine-cdm}/share/google/chrome/WidevineCdm/* $out/opt/helium/WidevineCdm/
  '';

  # Define the FHS wrapper
  fhs = buildFHSEnv {
    name = "helium-browser";
    
    multiPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs);
    targetPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.targetPkgs pkgs) ++ [ widevine-cdm ];
    
    runScript = writeScript "helium-wrapper" ''
      # Symlink WidevineCdm to user configuration directory
      # This helps if the browser ignores flags and looks in default locations
      mkdir -p $HOME/.config/net.imput.helium
      ln -snf ${widevine-cdm}/share/google/chrome/WidevineCdm $HOME/.config/net.imput.helium/WidevineCdm

      exec ${heliumRoot}/opt/helium/helium \
        --widevine-cdm-path=${widevine-cdm}/share/google/chrome/WidevineCdm \
        --widevine-cdm-version=${widevine-cdm.version} \
        "$@"
    '';
  };
in
  symlinkJoin {
    name = "${pname}-${version}";
    paths = [ fhs ];

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

