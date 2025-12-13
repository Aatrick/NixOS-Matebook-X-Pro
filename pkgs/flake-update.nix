{ pkgs ? import <nixpkgs> {}, nix-latest-update, flake_path, flake_config }:

pkgs.writeShellScriptBin "flake-update" ''
    cd ${flake_path}
    # if ! ${pkgs.git}/bin/git diff-index --quiet HEAD --; then
    #   ${pkgs.coreutils}/bin/echo "The repository contains uncommitted changes. Cancelled."
    #   exit 1
    # fi

    ${pkgs.nix}/bin/nix flake update --flake ${flake_path}

    ${pkgs.git}/bin/git add flake.lock > /dev/null 2>&1
    ${pkgs.git}/bin/git commit -m "update" > /dev/null 2>&1

    sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${flake_path}\#${flake_config} --impure;
    # then
    #   ${pkgs.git}/bin/git push > /dev/null 2>&1
    #   ${pkgs.coreutils}/bin/echo "Updated successfully"
    #   ${nix-latest-update}/bin/nix-latest-update
    #   exit 0
    # else
    #   ${pkgs.coreutils}/bin/echo "Update failed"
    #   ${pkgs.git}/bin/git reset --hard HEAD~1 > /dev/null 2>&1
    #   exit 1
    # fi
''
