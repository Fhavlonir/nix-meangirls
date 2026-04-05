{
  self,
  inputs,
  ...
}: {
  flake.ONK1WKS9Configuration = {
    pkgs,
    lib,
    ...
  }: {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJhieS1XLEEGjAEUQT9KW7QEeOwvIXmnnZ9xWQEfDQh root@pvgj";
      masterIdentities = [./id_ed25519_sk.pub];
      localStorageDir = ./. + "/secrets/rekeyed/";
    };
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
    launchd.daemons."sysctl-vram-limit" = {
      command = "/usr/sbin/sysctl iogpu.wired_limit_mb=115200";
      serviceConfig.RunAtLoad = true;
    };
    homebrew = {
      enable = true;
      onActivation.cleanup = "zap";
      brews = [
        "mpd"
        #"percona-server"
      ];
      casks = [
        "gimp"
        "inkscape"
        "openmw"
        "openttd"
        "steam"
        "windows-app"
        "Sikarugir-App/sikarugir/sikarugir"
      ];
    };
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      download-buffer-size = 524288000;
    };
    services.yabai = {
      enable = true;
      config = {
        focus_follows_mouse = "autoraise";
        layout = "bsp";
        auto_balance = "on";
        left_padding = 10;
        right_padding = 10;
        top_padding = 10;
        bottom_padding = 10;
        window_gap = 10;
      };
    };
    nixpkgs.config = {
      allowUnfree = true;
    };
    environment.systemPackages = with pkgs; [
      audacity
      firefox
      ghostty-bin
      mpv
      signal-desktop
      thunderbird
      vlc-bin
      wireguard-tools
    ];
  };
}
