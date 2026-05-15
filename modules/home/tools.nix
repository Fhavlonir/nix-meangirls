{config, ...}: let
  hmModules = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.tools = {pkgs, ...}: {
    imports = with hmModules; [
      direnv
      ssh
      vim
      yazi
    ];
  };
}
