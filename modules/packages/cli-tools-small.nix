{
  flake.modules.homeManager.cli-tools = {pkgs, ...}: {
    home.packages = with pkgs; [
      bat
      btop
      curl
      duf
      fastfetch
      fd
      gdu
      gitFull
      lsd
      ripgrep
      watch
      wireguard-tools
      yazi
    ];
  };
}
