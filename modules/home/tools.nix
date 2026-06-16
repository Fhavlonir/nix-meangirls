{config, ...}: {
  flake.modules.homeManager.tools = {pkgs, ...}: {
    imports = with config.flake.modules.homeManager; [
      direnv
      ssh
      yazi
      vim
    ];
  };
}
