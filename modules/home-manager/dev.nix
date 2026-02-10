{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  # Tell rust-analyzer where to find the rust standard library source
  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    JAVA_HOME = "${pkgs.jdk21}";
    LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
      stdenv.cc.cc.lib
      zlib
      glib
      libxkbcommon
      fontconfig
      freetype
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libICE
      xorg.libSM
      xorg.libxcb
      xorg.libXau
      xorg.libXdmcp
      libGL
    ];
  };

  home.packages = with pkgs; [
    pkgs-unstable.vscode-fhs

    #zeal
    git
    gh
    blackbox-terminal

    msedit

    # C / C++ / Native Build
    gcc
    cmake
    ninja
    pkg-config

    # Vulkan & Shaders
    # vulkan-headers
    # vulkan-loader
    # vulkan-tools
    # shaderc # Provides 'glslc' for shader compilation

    # Rust
    cargo
    rustc
    rust-analyzer
    rustfmt

    # Python
    (python312.withPackages (
      ps: with ps; [
        jupyter
        ipykernel
        tkinter
        opencv4
      ]
    ))
    pkgs-unstable.uv
    pkgs-unstable.ty

    # Java
    jdk21
    jdt-language-server
    maven
    direnv

    # Kotlin
    kotlin
    kotlin-language-server
    gradle

    nil
    nixd # Nix language server for zeditor
    alejandra
    nixfmt

    bun
    gemini-cli
    update-gemini
    nix-update

    tree
    obsidian
    parsec-bin
    graphviz
  ];
}
