{ pkgs ? import <nixpkgs> {}, flake_path, flake_config }:

pkgs.writeShellScriptBin "nix-clean-boot" ''
    ${pkgs.nix}/bin/nix flake update --flake ${flake_path}
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flake_path}\#${flake_config}
    rm /nix/var/nix/gcroots/auto/*
    nix-store --gc
    nix-collect-garbage -d
''
