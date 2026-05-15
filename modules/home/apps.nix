{config, ...}: let
  hmModules = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.apps = {pkgs, ...}: {
    imports = with hmModules; [
      firefox
      ghostty
    ];
  };
}
