_: {
  flake.modules.homeManager.direnv = _: {
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
