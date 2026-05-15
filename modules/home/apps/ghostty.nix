{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.ghostty = {
    pkgs,
    lib,
    ...
  }: let
    ghostty-shaders = pkgs.fetchFromGitHub {
      owner = "KroneCorylus";
      repo = "ghostty-shader-playground";
      rev = "b539cea7b34cdc883726db018ae09e8e3f862aea";
      sha256 = "dfk2Ti+T1jEC5M8ijaO1KnfzW6MP5yswovZgoptqO3A=";
    };
  in {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      package = pkgs.ghostty-bin;
      settings = {
        background-blur = true;
        macos-titlebar-style = "hidden";
        custom-shader = "${ghostty-shaders}/shaders/cursor_blaze.glsl";
      };
    };
  };
}
