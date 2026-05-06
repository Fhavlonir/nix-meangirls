{
  self,
  inputs,
  ...
}: {
  #imports = [inputs.agenix-rekey.flakeModule];
  flake.agenix-rekey = inputs.agenix-rekey.configure {
    userFlake = self;
    nixosConfigurations = self.nixosConfigurations;
    darwinConfigurations = self.darwinConfigurations or {};
    # Example for colmena:
    # nixosConfigurations = ((colmena.lib.makeHive self.colmena).introspect (x: x)).nodes;
  };
}
