_: {
  flake.modules.homeManager.cli-tools-small = {pkgs, ...}: {
    home.packages = with pkgs; [
      curl
      fastfetch
      fd
      gdu
      git
      lsd
      openssh
      ripgrep
      watch
      yazi
    ];
  };
}
