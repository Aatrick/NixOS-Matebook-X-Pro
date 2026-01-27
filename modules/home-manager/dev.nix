{
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # Tell rust-analyzer where to find the rust standard library source
  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    JAVA_HOME = "${pkgs.jdk21}";
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib";
  };

  home.packages = with pkgs; [
    pkgs-unstable.zed-editor
    #zeal
    git
    gh
    blackbox-terminal

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
      ]
    ))
    pkgs-unstable.uv
    pyrefly

    # Java
    jdk21
    jdt-language-server
    maven

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
  ];
}
