{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    envycontrol = {
      url = "github:bayasdev/envycontrol";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Define overlays
    overlays = [
      (import ./pkgs/overlay.nix)
    ];

    nixpkgsConfig = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };

    # Import unstable pkgs with overlay
    pkgs-unstable = import nixpkgs-unstable {
      inherit system overlays;
      config = nixpkgsConfig;
    };
  in {
    # Formatter for 'nix fmt'
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations = {
      "mach-w19c" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs pkgs-unstable;};
        modules = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config = nixpkgsConfig;
          }
          ./hosts/mach-w19c/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      "homelab" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self inputs pkgs-unstable;};
        modules = [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config = nixpkgsConfig;
          }
          ./hosts/homelab/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      "aatricks@fedora" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config = nixpkgsConfig;
        };
        extraSpecialArgs = {inherit self inputs pkgs-unstable;};
        modules = [
          ./hosts/fedora/aatricks.nix
        ];
      };
    };
  };
}
