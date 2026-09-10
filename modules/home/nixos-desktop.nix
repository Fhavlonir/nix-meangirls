{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.home-desktop = {pkgs, ...}: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit inputs;
        inherit (config) vars;
      };

      users.${config.vars.username} = {
        imports = with config.flake.modules.homeManager; [
          tools
          apps
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
        home = {
          keyboard.layout = "se";
          inherit (config.vars) username;
          stateVersion = "25.11";
        };
      };
    };
  };
}
