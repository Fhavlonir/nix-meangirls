{
  config,
  inputs,
  ...
}: {
  flake.modules.darwin.home = {pkgs, ...}: {
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
          shell
          cli-tools
          apps
          darwin-desktop
          tools
          stylix
        ];
        services.yubikey-agent.enable = true;

        home = {
          inherit (config.vars) username;
          homeDirectory = "/Users/${config.vars.username}";
          stateVersion = "25.11";
        };
      };
    };
  };
}
