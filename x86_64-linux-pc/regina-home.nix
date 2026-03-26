{
  pkgs,
  lib,
  ...
}: {
  home = {
    username = "philip";
    homeDirectory = "/home/philip";
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
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/vnd.comicbook+zip" = ["org.pwmt.zathura.desktop"];
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
    associations.added = {
      "application/vnd.comicbook+zip" = ["org.pwmt.zathura.desktop"];
      "application/pdf" = ["org.pwmt.zathura.desktop"];
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
    fuzzel = {
      enable = true;
      #settings.main = {
      #  icon-theme = "Papirus";
      #};
    };
    i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks = [
            {
              block = "focused_window";
              format = " $title.str(max_w:192) |";
            }
            {
              block = "net";
              format = " $icon  $ssid ";
            }
            {
              block = "disk_space";
              path = "/";
              info_type = "available";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
            }
            {
              block = "battery";
              format = " $icon $percentage ";
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "sound";
            }
            {
              block = "time";
              interval = 60;
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            }
          ];
          settings = {
            theme = {
              theme = "native";
            };
          };
          icons = "material-nf";
        };
      };
    };
    kitty = {
      enable = true;
      settings = {
        cursor_trail = 1;
      };
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
      plugins = {
        epub-preview = pkgs.fetchFromGitHub {
          owner = "ElricleNecro";
          repo = "epub-preview.yazi";
          rev = "3d4e96fb1acc7f64c79430b9e255ea961485f000";
          sha256 = "sha256-u9d2jeBuORUT4SeU0GdRKz04kEsY6XEFld/wwNqZ2v4=";
        };
      };
      settings = {
        mgr = {
          ratio = [1 3 4];
        };
        plugin = {
          prepend_previewers = [
            {
              name = "*.cbr";
              run =  "epub-preview" ;
            }
            {
              name = "*.cbz";
              run =  "epub-preview" ;
            }
            {
              mime = "application/epub+zip";
              run =  "epub-preview" ;
            }
          ];
        };
        open = {
          prepend_rules = [
            {
              name = "*.cbr";
              use = [ "open" "reveal" ];
            }
            {
              name = "*.cbz";
              use = [ "open" "reveal" ];
            }
          ];
        };
      };
    };
    home-manager.enable = true;
  };
  home.stateVersion = "24.11";
}
