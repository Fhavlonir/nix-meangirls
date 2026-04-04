{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.pvgj-server = inputs.nixos.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      inputs.determinate.nixosModules.default
      inputs.agenix.nixosModules.default
      (inputs.nixpkgs.outPath + "/nixos/modules/profiles/minimal.nix")
      (inputs.nixpkgs.outPath + "/nixos/modules/profiles/headless.nix")
      self.nixosModules.pvgj-configuration
      self.nixosModules.pvgj-disk-config
      self.nixosModules.pvgj-hardware-configuration
    ];
  };
}
