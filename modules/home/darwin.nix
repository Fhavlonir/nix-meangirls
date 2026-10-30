{
  config,
  inputs,
  ...
}: {
  flake.modules.darwin.home = {
    imports = [inputs.home-manager.darwinModules.home-manager];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        inherit (config) vars;
      };

      users.${config.vars.username} = _: {
        imports = with config.flake.modules.homeManager; [
          common
          cli-tools
          apps
          tools
          stylix
        ];
        services.yubikey-agent.enable = true;
        home.homeDirectory = "/Users/${config.vars.username}";
      };
    };
  };
}
