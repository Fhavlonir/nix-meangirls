_: {
  flake.modules.homeManager.darwin-desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      macmon
      audacity
      deluge
      #electrum
      ghostty-bin
      signal-desktop
      mpv
    ];
  };
}
