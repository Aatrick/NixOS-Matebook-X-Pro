{
  pkgs ? import <nixpkgs> {},
  nix-latest-update,
  flake_path,
  flake_config,
}:
pkgs.writeShellScriptBin "flake-update" ''
  ${pkgs.nix}/bin/nix flake update --flake ${flake_path}

  sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flake_path}\#${flake_config} --impure;
''
