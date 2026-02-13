{
  pkgs,
  pkgs-unstable,
  ...
}: let
  android-sdk = (pkgs-unstable.androidenv.composeAndroidPackages {
    platformVersions = ["34" "35" "36"];
    buildToolsVersions = ["34.0.0" "35.0.0" "36.0.0"];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = ["google_apis_playstore"];
    abiVersions = ["x86_64" "arm64-v8a"];
    includeSources = false;
    includeNDK = false;
    useGoogleAPIs = true;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;m2repository"
      "extras;android;m2repository"
    ];
  }).androidsdk;
in {
  home.packages = [
    android-sdk
  ];

  home.sessionVariables = {
    ANDROID_HOME = "${android-sdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${android-sdk}/libexec/android-sdk";
  };
}
