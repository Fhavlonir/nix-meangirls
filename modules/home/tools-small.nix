{config, ...}: {
  flake.modules.homeManager.tools-small = {
    imports = with config.flake.modules.homeManager; [
      shell
      ssh
    ];
  };
}
