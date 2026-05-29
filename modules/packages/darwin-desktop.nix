_: {
  flake.modules.homeManager.darwin-desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      audacity
      colmena
      deluge
      ghostty-bin
      macmon
      mpv
      signal-desktop
    ];
  };
}
