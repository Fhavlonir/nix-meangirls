{
  flake.modules.homeManager.ghostty = {pkgs, ...}: let
    ghostty-shaders = pkgs.fetchFromGitHub {
      owner = "hackrdotsh";
      repo = "ghostty-shaders";
      rev = "6b3e4d1c88e62989e5fa626a9fa59b4a8664ce6f";
      hash = "sha256-ixShV7afxxD1k9+gCeLBTfsGGxHuNZjKM5OwAkdtiqw=";
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
        custom-shader = "${ghostty-shaders}/cursor_blaze.glsl";
      };
    };
  };
}
