{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    #pkgs-unstable.zed-editor
    #zeal
    git
    gh
    blackbox-terminal
    pkgs-unstable.vscode

    # C / C++
    gcc
    # clang-tools
    # clang
    # cmakeWithGui
    # gnumake

    # Rust
    rustup

    # Python
    python312
    uv

    # Java
    jdk
    maven

    nil
    nixd # Nix language server for zeditor
    alejandra

    nodejs
    pkgs-unstable.github-copilot-cli
  ];

}
