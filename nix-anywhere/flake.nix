{
  description = "Home Manager configuration of philip.johansson";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf/v0.8";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nvf,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."philip.johansson" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        nvf.homeManagerModules.default
        ./home.nix
        ./vim.nix
      ];
    };
  };
}
