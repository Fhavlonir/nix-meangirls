{inputs, ...}: {
  flake.modules.homeManager.stylix = {
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.stylix.homeModules.default];

    stylix = {
      enable = true;
      autoEnable = false;
      targets = {
        btop.enable = true;
        firefox.enable = true;
        firefox.profileNames = ["philip.johansson"];
        fish.enable = true;
        ghostty.enable = true;
        mpv.enable = true;
        nvf.enable = true;
        yazi.enable = true;
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
