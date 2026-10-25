{config, ...}: {
  flake.modules.homeManager.common = {
    home = {
      inherit (config.vars) username;
      stateVersion = "25.11";
      keyboard.layout = "se";
    };
  };
}
