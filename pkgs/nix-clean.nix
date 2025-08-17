{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellScriptBin "nix-clean" ''
    ${pkgs.nix}/bin/nix-env -u --always
    ${pkgs.nix}/bin/nix-store --gc
    ${pkgs.nix}/bin/nix-collect-garbage -d
''
