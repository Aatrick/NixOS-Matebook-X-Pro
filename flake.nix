{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
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
    nixosConfigurations =
    {
      "mach-w19c" = nixpkgs.lib.nixosSystem {
       	system = "x86_64-linux";
       	specialArgs = { inherit self inputs pkgs-unstable; };
       	modules = [
       	  ./hosts/mach-w19c/configuration.nix
          inputs.home-manager.nixosModules.default
       	];
      };
    };
  };
}
