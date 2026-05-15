{
  config,
  inputs,
  ...
}: let
  targetSystem = "x86_64-linux";

  sharedSpecialArgs = {
    inherit inputs;
    inherit (config) vars;
  };

  pvgjAspects = with config.flake.modules.nixos; [
    common
    home
  ];

  pvgjInline = {
    networking.hostName = "pvgj";
    networking.domain = "se";
  };

  pvgjModules = pvgjAspects ++ [pvgjInline];
in {
  flake.nixosConfigurations.pvgj = inputs.nixpkgs.lib.nixosSystem {
    system = targetSystem;
    modules = pvgjModules;

    specialArgs = sharedSpecialArgs;
  };
}
