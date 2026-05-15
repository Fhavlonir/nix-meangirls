_: {
  flake.modules.homeManager.yazi = _: {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      shellWrapperName = "y";
      settings = {
        mgr = {
          ratio = [
            1
            3
            4
          ];
        };
        preview = {
          max_width = 1600;
          max_height = 2000;
        };
        opener.play = [
          {
            run = "mpv %s";
            orphan = true;
            for = "unix";
          }
        ];
      };
    };
  };
}
