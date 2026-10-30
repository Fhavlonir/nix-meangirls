{
  flake.modules.homeManager.cli-tools-small = {pkgs, ...}: {
    home.packages = with pkgs; [
      bat
      btop
      curl
      duf
      fastfetch
      fd
      ffmpeg
      gdu
      gitFull
      gitoxide
      graphicsmagick
      lsd
      openssh
      oxipng
      pandoc
      ripgrep
      tealdeer
      texliveSmall
      watch
      wireguard-tools
      yazi
      yt-dlp
    ];
  };
}
