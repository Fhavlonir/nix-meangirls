{config, ...}: {
  flake.modules.homeManager.tools = {
    imports = with config.flake.modules.homeManager; [
      direnv
      ssh
      yazi
      ripgrep
    ];
  };
}
