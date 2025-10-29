{
  pkgs,
  lib,
  ...
}: {
  home = {
    username = "alice";
    homeDirectory = "/home/alice";
    keyboard.layout = "sv";
  };
  stylix = {
    iconTheme = {
      enable = true;
      light = "Papirus";
      dark = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "fuzzel";
      input."*".xkb_layout = "se";
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 10;
      };
      keybindings = lib.mkOptionDefault {
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
        "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
        "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
      };
      window.titlebar = false;
      bars = [
        {
          position = "top";
          statusCommand = "i3status-rs config-default.toml";
        }
      ];
    };
  };

  programs = {
    mpv.enable = true;
    mpv.config = {
      hwdec = "vaapi";
      vo = "gpu";
      profile = "gpu-hq";
      gpu-context = "wayland";
    };
    git.enable = true;
    git.lfs.enable = true;
    kitty = {
      enable = true;
      settings = {
        cursor_trail = 1;
      };
    };
    home-manager.enable = true;
  };
  home.stateVersion = "24.11";
}
