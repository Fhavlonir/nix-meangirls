_: {
  flake.modules.homeManager.ssh = _: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraConfig = "SetEnv TERM=xterm-256color";
      matchBlocks."*" = {
        forwardAgent = true;
        compression = true;
      };
    };
  };
}
