{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.home = {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        inherit (config) vars;
      };

      users.${config.vars.username} = {
        imports = with config.flake.modules.homeManager; [
          common
          tools
        ];
      };
    };
  };
}
