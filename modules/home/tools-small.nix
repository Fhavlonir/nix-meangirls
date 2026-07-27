{config, ...}: {
  flake.modules.homeManager.tools-small = {pkgs, ...}: {
    imports = with config.flake.modules.homeManager; [
      ssh
      yazi
    ];
  };
}
