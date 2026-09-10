{
  config,
  inputs,
  ...
}: {
  flake.modules.homeManager.stylix = {
    osConfig,
    pkgs,
    lib,
    ...
  }: let
    image =
      if lib.filesystem.pathIsRegularFile ../../pics/${osConfig.networking.hostName}.avif
      then ../../pics/${osConfig.networking.hostName}.avif
      else null;
  in {
    imports = [inputs.stylix.homeModules.default];

    stylix = {
      enable = true;
      inherit image;
      autoEnable = false;
      targets = {
        btop.enable = true;
        firefox.enable = true;
        firefox.profileNames = ["${config.vars.username}"];
        fish.enable = true;
        ghostty.enable = true;
        mpv.enable = true;
        nvf.enable = true;
        yazi.enable = true;
        fuzzel.enable = true;
        sway.enable = true;
      };
      opacity = {
        terminal = 0.5;
        popups = 0.5;
      };
      fonts = {
        monospace = {
          package = pkgs.fira-code;
          name = "Fira Code";
        };
      };
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    };
  };
}
