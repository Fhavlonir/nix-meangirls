_: {
  flake.modules.homeManager.darwin-desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      audacity
      deluge
      #electrum
      ghostty-bin
      signal-desktop
      mpv
    ];
  };
}
