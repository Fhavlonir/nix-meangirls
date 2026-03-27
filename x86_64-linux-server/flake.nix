{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    #nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    disko,
    determinate,
    ...
  }: {
    # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
    nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        #determinate.nixosModules.default
        (nixpkgs.outPath + "/nixos/modules/profiles/minimal.nix")
        (nixpkgs.outPath + "/nixos/modules/profiles/headless.nix")
        #(nixpkgs.outPath + "/nixos/modules/profiles/perlless.nix")
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
