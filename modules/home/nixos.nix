{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.home = _: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit inputs;
        inherit (config) vars;
      };

      users.${config.vars.username} = _: {
        imports = with config.flake.modules.homeManager; [
          shell
          cli-tools
          tools
        ];

        home = {
          inherit (config.vars) username;
          homeDirectory = "/Users/${config.vars.username}";
          stateVersion = "25.11";
        };
      };
    };
  };
}
