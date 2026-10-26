{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.home-desktop = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.self.modules.nixos.home
    ];

    home-manager = {
      users.${config.vars.username} = {
        imports = with config.flake.modules.homeManager; [
          cli-tools
          apps
          tools
          stylix
        ];
        programs.fuzzel = {
          enable = true;
        };
        wayland.windowManager.sway = {
          enable = true;

          config = {
            input."*".xkb_layout = "se";
            menu = "fuzzel";
            terminal = "ghostty";
            modifier = "Mod4";
            gaps = {
              inner = 10;
              outer = 10;
              smartBorders = "on";
              smartGaps = "on";
            };
            window.titlebar = false;
          };
        };
      };
    };
  };
}
