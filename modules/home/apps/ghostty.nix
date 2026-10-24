{
  flake.modules.homeManager.ghostty = {pkgs, ...}: let
    ghostty-shaders = pkgs.fetchFromGitHub {
      owner = "hackrdotsh";
      repo = "ghostty-shaders";
      rev = "85898f08fcf4a9274e418912098e99e00a5f8350";
      sha256 = "WwiFYbzEgDux+Zu4qh4ZrYNHhIRKsMzzS9BrfUfokco=";
    };
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;
  in {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      inherit package;
      settings = {
        background-blur = true;
        macos-titlebar-style = "hidden";
        custom-shader = "${ghostty-shaders}/smear_cursor_blocks.glsl";
      };
    };
  };
}
