{
  pkgs,
  pkgs-unstable,
  ...
}: let
  gemini-cli-latest = pkgs.callPackage ../../pkgs/gemini-cli-latest.nix {};
  update-gemini = pkgs.callPackage ../../pkgs/update-gemini.nix {};
in {
  # Tell rust-analyzer where to find the rust standard library source
  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    JAVA_HOME = "${pkgs.jdk17}";
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

    # Vulkan & Shaders (Required for LLMEdge GPU backend)
    vulkan-headers
    vulkan-loader
    vulkan-tools
    shaderc # Provides 'glslc' for shader compilation

    # Rust
    cargo
    rustc
    rust-analyzer

    # Python
    python312
    uv
    pyrefly

    # Java
    jdk17
    maven

    nil
    nixd # Nix language server for zeditor
    alejandra

    nodejs
    # pkgs-unstable.gemini-cli-bin
    gemini-cli-latest
    update-gemini
  ];
}
