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
  };

  home.packages = with pkgs; [
    pkgs-unstable.vscode
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
    python312
    uv

    # Java
    jdk21
    maven

    # Kotlin
    kotlin
    kotlin-language-server
    gradle

    nil
    nixd # Nix language server for zeditor
    alejandra
    nixfmt

    nodejs
    # pkgs-unstable.gemini-cli-bin
    gemini-cli
    update-gemini
    nix-update

    tree
  ];
}
