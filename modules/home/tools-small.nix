{config, ...}: {
  flake.modules.homeManager.tools-small = {pkgs, ...}: {
    imports = with config.flake.modules.homeManager; [
      shell
      ssh
    ];
  };
}
