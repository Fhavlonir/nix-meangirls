{
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations.ONK1WKS9 = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      self.ONK1WKS9Configuration
      self.philip-home-gui
      inputs.home-manager.darwinModules.home-manager
    ];
  };
}
