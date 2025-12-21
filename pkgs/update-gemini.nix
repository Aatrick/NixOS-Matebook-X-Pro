{pkgs ? import <nixpkgs> {}}:
pkgs.writeShellScriptBin "update-gemini" ''
  # Find the project root
  if [ -f "flake.nix" ]; then
    ROOT="."
  elif [ -f "config/flake.nix" ]; then
    ROOT="config"
  elif [ -f "../flake.nix" ]; then
    ROOT=".."
  else
    echo "Error: Could not find flake.nix. Run this from your config directory."
    exit 1
  fi

  cd "$ROOT"
  echo "Updating gemini-cli in $PWD..."

  ${pkgs.nix-update}/bin/nix-update --flake . gemini-cli --version=latest --override-filename pkgs/gemini-cli-latest.nix

  echo "Done."
''
