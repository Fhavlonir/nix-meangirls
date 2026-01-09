{
  self,
  pkgs,
  ...
}: {
  networking.hostName = "ONK1WKS9";
  nix.enable = false;
  users.users."philip.johansson".home = "/Users/philip.johansson";
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
    primaryUser = "philip.johansson";
  };
  services.openssh.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    brews = [
      "mpd"
      "percona-server"
    ];
    casks = [
      "amethyst"
      "gimp"
      "inkscape"
      "openmw"
      "openttd"
      "steam"
      "windows-app"
    ];
  };
  nix.settings = {
    experimental-features = "nix-command flakes";
    download-buffer-size = 524288000;
  };
  #services.yabai = {
  #  enable = true;
  #  config = {
  #    focus_follows_mouse = "autoraise";
  #    layout = "bsp";
  #    auto_balance = "on";
  #    left_padding = 10;
  #    right_padding = 10;
  #    top_padding = 10;
  #    bottom_padding = 10;
  #    window_gap = 10;
  #  };
  #};
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    #fjord.outputs.packages.aarch64-darwin.fjordlauncher
    audacity
    bitwarden-desktop
    firefox
    ghostty-bin
    mpv
    openscad
    signal-desktop-bin
    thunderbird
    vlc-bin
    wireguard-tools
    whisky
  ];
}
