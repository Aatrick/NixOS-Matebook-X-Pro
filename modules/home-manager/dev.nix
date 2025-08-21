{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    #pkgs-unstable.zed-editor
    zeal
    git
    gh
    blackbox-terminal
    pkgs-unstable.vscode

    # C / C++
    clang-tools
    clang
    cmakeWithGui
    gnumake

    # Rust
    cargo
    rustc
    rust-analyzer

    # Python
    python312
    uv
    ruff

    nil
    nixd # Nix language server for zeditor
    alejandra

    nodejs
  ];

}
