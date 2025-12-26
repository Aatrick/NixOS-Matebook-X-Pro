{
  pkgs ? import <nixpkgs> {},
  nix-latest-update,
  update-gemini,
  flake_path,
  flake_config,
}:
pkgs.writeShellScriptBin "flake-update" ''
  echo "Updating gemini-cli..."
  cd ${flake_path}
  ${update-gemini}/bin/update-gemini

  ${pkgs.nix}/bin/nix flake update --flake ${flake_path}

  sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flake_path}\#${flake_config} --impure;
''
