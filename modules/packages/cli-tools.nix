_: {
  flake.modules.homeManager.cli-tools = {pkgs, ...}: {
    home.packages = with pkgs; [
      age-plugin-yubikey
      bat
      btop
      curl
      duf
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
      svtplay-dl
      tealdeer
      texliveSmall
      watch
      wireguard-tools
      yazi
      yt-dlp
    ];
  };
}
