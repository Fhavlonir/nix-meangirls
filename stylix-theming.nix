{
  stylix,
  pkgs,
  bg,
  ...
}: let
  scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
in {
  stylix = {
    enable = true;
    opacity = {
      terminal = 0.8;
      popups = 0.8;
    };
    base16Scheme = scheme;
    image = pkgs.runCommand "image.jpg" {} ''
      ${pkgs.imagemagick}/bin/magick ${bg} -scale 1920x1080\>^ -extent 1920x1080 -ordered-dither o3x3 -remap <(eval "${pkgs.imagemagick}/bin/magick -size 1x1" $( ${pkgs.yq}/bin/yq -r '.palette | to_entries | map(select(.key | startswith("base"))) | from_entries.[]' ${scheme} | sed 's/#/xc:#/g')" +append -colors 4 png:-") -format jpg $out
    '';
  };
}
