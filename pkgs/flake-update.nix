{ pkgs ? import <nixpkgs> {}, flake_path, flake_config }:

pkgs.writeShellScriptBin "flake-update" ''
    ${pkgs.nix}/bin/nix flake update --flake ${flake_path}
    ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flake_path}\#${flake_config}
''
