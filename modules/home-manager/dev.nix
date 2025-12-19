{ pkgs, pkgs-unstable, ... }:
{
  # Tell rust-analyzer where to find the rust standard library source
  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  home.packages = with pkgs; [
    pkgs-unstable.zed-editor
    #zeal
    git
    gh
    blackbox-terminal
    # pkgs-unstable.vscode

    # C / C++
    gcc
    # clang-tools
    # clang
    # cmakeWithGui
    # gnumake

    # Rust
    cargo
    rustc
    rust-analyzer

    # Python
    python312
    uv
    pyrefly

    # Java
    jdk
    maven

    nil
    nixd # Nix language server for zeditor
    alejandra

    nodejs
    pkgs-unstable.gemini-cli-bin
  ];
}
