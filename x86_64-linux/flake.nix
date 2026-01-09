{
  description = "My main config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stylix.url = "github:danth/stylix";
    #chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    fjord.url = "github:hero-persson/FjordLauncherUnlocked";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf/v0.8";
  };

  outputs = {
    self,
    nixpkgs,
    fjord,
    stylix,
    #chaotic,
    home-manager,
    nvf,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowunfree = true;
      };
    };
  in {
    nixosConfigurations = {
      regina-george = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system;};
        modules = [
          ./configuration.nix
          ./regina-configuration.nix
            (import ./stylix-theming.nix {
              #bg = pkgs.fetchurl {
              #  url = "https://pvgj.se/pics/regina.avif";
              #  sha256 = "T0i1OH+Wt28AFBi9lW3Cdi3MKiCqnz6000PG4jWqEvQ=";
              #};
              lib = pkgs.lib;
              pkgs = pkgs;
              stylix = {};
            })
            stylix.nixosModules.stylix
            nvf.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.philip = import ./regina-home.nix;
          }
        ];
      };
      karen-smith = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system;};
        modules = [
          ./configuration.nix
          ./karen-configuration.nix
            (import ./stylix-theming.nix {
              #bg = pkgs.fetchurl {
              #  url = "https://pvgj.se/pics/karen.avif";
              #  sha256 = "Y5+BcCwGhf2xRUehvLfekFuRQb5ngD/SL6lguy2D6E0=";
              #};
              lib = pkgs.lib;
              pkgs = pkgs;
              stylix = {};
            })
            (
              {pkgs, ...}: {
                nixpkgs.overlays = [fjord.overlays.default];
                environment.systemPackages = [pkgs.fjordlauncher];
              }
            )
            #chaotic.nixosModules.nyx-cache
            #chaotic.nixosModules.nyx-overlay
            #chaotic.nixosModules.nyx-registry
            nvf.nixosModules.default
            stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.philip = import ./karen-home.nix;
          }
        ];
      };
    };
  };
}
