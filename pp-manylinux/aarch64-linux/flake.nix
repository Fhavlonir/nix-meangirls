{
  description = "PP:s nya server?🥺
                                👉 👈";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #stylix.url = "github:danth/stylix";
    #nvf.url = "github:notashelf/nvf/v0.8";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        #allowunfree = true;
      };
    };
  in {
    nixosConfigurations = {
      pp-server = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system;};
        modules = [
          ./configuration.nix
          (import ./stylix-theming.nix {
            lib = pkgs.lib;
            pkgs = pkgs;
            stylix = {};
          })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };
  };
}
