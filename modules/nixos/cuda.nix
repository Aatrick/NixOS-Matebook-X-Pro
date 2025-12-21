{
  pkgs,
  lib,
  config,
  ...
}: {
  options.winter.cuda.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable CUDA development tooling and OpenGL support.";
  };

  config = lib.mkIf config.winter.cuda.enable {
    # Ensure CUDA support is enabled in nixpkgs
    nixpkgs.config.cudaSupport = true;

    # Graphics stack basics (useful for CUDA apps that need GL)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # System-wide dev tooling akin to the previous devShell contents
    environment.systemPackages = with pkgs; [
      ffmpeg
      fmt.dev
      cudaPackages.cuda_cudart
      cudatoolkit
      cudaPackages.cudnn
      libGLU
      libGL
      xorg.libXi
      xorg.libXmu
      freeglut
      xorg.libXext
      xorg.libX11
      xorg.libXv
      xorg.libXrandr
      zlib
      ncurses
      stdenv.cc
      binutils
      uv
    ];

    # Minimal, non-invasive env vars commonly expected by CUDA build tooling
    environment.variables = {
      CUDA_PATH = pkgs.cudatoolkit; # e.g., /nix/store/...-cudatoolkit
      CUDA_HOME = pkgs.cudatoolkit;
      CMAKE_PREFIX_PATH = lib.mkBefore "${pkgs.fmt.dev}";
      PKG_CONFIG_PATH = lib.mkBefore "${pkgs.fmt.dev}/lib/pkgconfig";
    };
  };
}
