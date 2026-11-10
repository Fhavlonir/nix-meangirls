{config, ...}: {
  flake.modules.homeManager.tools = {
    imports = with config.flake.modules.homeManager; [
      direnv
      pretty-utils
      shell
      ssh
      vim
      yazi
    ];
  };
}
