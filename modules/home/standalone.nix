{
  config,
  inputs,
  ...
}: {
  flake.homeConfigurations.${config.vars.username} = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = {inherit inputs;};
    modules = with config.flake.modules.homeManager; [
      common
      tools-small
      nvim
      {
        home.homeDirectory = "/home/${config.vars.username}";
        targets.genericLinux.enable = true;
        programs.home-manager.enable = true;
      }
    ];
  };
}
