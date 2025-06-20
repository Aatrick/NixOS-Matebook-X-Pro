{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware }:
  let
    system = "x86_64-linux";
    nixpkgsConfig = {
      allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = nixpkgsConfig;
    };
  in
  {
    nixosConfigurations = {
      "mach-w19c" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self system pkgs-unstable nixos-hardware; };
        modules = [
          ./hosts/mach-w19c.nix
        ];
      };
    };

    homeConfigurations = {
      "aatricks" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./users/aatricks/home.nix
        ];
        extraSpecialArgs = { inherit system pkgs-unstable; };
      };
    };
  };
}
