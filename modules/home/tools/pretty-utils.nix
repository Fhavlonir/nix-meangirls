{
  flake.modules.homeManager.pretty-utils = {
    programs = {
      eza = {
        enable = true;
        enableFishIntegration = true;
      };
      bat = {
        enable = true;
      };
      fish.shellAliases = {cat = "bat";};
    };
  };
}
