{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellScriptBin "nix-latest-update" ''
    nix store diff-closures $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)
''
