{ pkgs, pkgs-unstable, ... }: {

  imports = [
    ./git.nix
    ./gnome.nix
    ./shell.nix
    ./zed.nix
  ];

  home.username = "aatricks";
  home.homeDirectory = "/home/aatricks";
  nixpkgs.config.allowUnfree = true;
  # home.enableNixpkgsRelease = false;
  home.keyboard = {
    layout = "us";
    variant = "us";
  };

  home.packages = with pkgs; [

    # C / C++
    # gcc
    # clang-tools
    # clang
    # cmake
    # gnumake

    # Rust
    # cargo
    # rustc
    # rustup
    # rust-analyzer

    # Python
    # python3
    # uv
    # ruff

    foliate
    wineWowPackages.waylandFull

    vesktop
    # openrgb

    # Desktop
    texliveFull
    texstudio
    # python312Packages.pygments

    # Dev
    zeal
    git
    gh
    blackbox-terminal
    pkgs-unstable.vscode

    # Nix
    nixd # Nix language server for zeditor
    nil

    # Base gnome app
    gnome-text-editor
    gnome-calculator
    file-roller
    nautilus

    # Tools
    fastfetch
    htop
    gnome-tweaks
    dconf-editor
    gnome-extension-manager
    steam-run

    orca-slicer
    spotify
    media-downloader
    vlc

    deskflow
  ];

  home.stateVersion = "25.05";
}
