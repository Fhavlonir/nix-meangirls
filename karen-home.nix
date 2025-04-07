{
  config,
  pkgs,
  lib,
  ...
}: {
  home = {
    username = "philip";
    homeDirectory = "/home/philip";
    keyboard.layout = "sv";
  };
  programs = {
    kitty = {
      enable = true;
      settings = {
        cursor_trail = 1;
      };
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        manager = {
          ratio = [1 3 4];
        };
      };
    };
    home-manager.enable = true;
  };
  home.stateVersion = "24.11";
}
