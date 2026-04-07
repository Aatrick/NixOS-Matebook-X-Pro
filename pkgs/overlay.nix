final: prev: {
  flake-update = final.callPackage ./flake-update.nix {};
  lsfg-vk = final.callPackage ./lsfg-vk.nix {};
  nix-clean-boot = final.callPackage ./nix-clean-boot.nix {};
  nix-clean = final.callPackage ./nix-clean.nix {};
  nix-latest-update = final.callPackage ./nix-latest-update.nix {};
  phpmyadmin-custom = final.callPackage ./phpmyadmin.nix {};
}
