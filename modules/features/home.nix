{
  self,
  inputs,
  ...
}: {
  flake.philip-home = {pkgs, ...}: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [
        inputs.nvf.homeManagerModules.default
        inputs.stylix.homeModules.stylix
        inputs.agenix.homeManagerModules.default
      ];
      extraSpecialArgs = {inherit inputs;};
      users."philip.johansson" = {
        imports = [
          self.homeModules.vim
        ];
        home = {
          shellAliases = {
            lt = "lsd -lh --tree";
            ls = "lsd";
            cat = "bat";
          };
          username = "philip.johansson";
          stateVersion = "25.05";
          packages = with pkgs; [
            erlang-language-platform
            android-tools
            bat
            btop
            curl
            duf
            exiftool
            fd
            ffmpeg
            figlet
            gdu
            gitFull
            gitoxide
            graphicsmagick
            lsd
            mediainfo
            ncmpcpp
            nmap
            jre
            openssh
            oxipng
            pandoc
            ripgrep
            svtplay-dl
            syncthing
            tealdeer
            texliveSmall
            watch
            xq
            xz
            yt-dlp
            zstd
          ];
        };
        services.yubikey-agent.enable = true;
        services.ssh-agent.enable = true;

        programs = {
          ssh = {
            enable = true;
            enableDefaultConfig = false;
            extraConfig = "SetEnv TERM=xterm-256color";
            matchBlocks."*" = {
              forwardAgent = true;
              compression = true;
            };
          };
          git = {
            enable = true;
            package = pkgs.gitFull;
            lfs.enable = true;
            settings.user = {
              name = "Philip Johansson";
              email = "philip.johansson@synotio.se";
            };
          };
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
          fish = {
            enable = true;
            interactiveShellInit = ''
              set fish_user_paths /etc/profiles/per-user/$USER/bin/ssh $fish_user_paths
              set -gx EDITOR nvim
              direnv hook fish | source
              set fish_greeting
              fastfetch
            '';
          };
          yazi = {
            enable = true;
            enableFishIntegration = true;
            shellWrapperName = "y";
            settings = {
              mgr = {
                ratio = [
                  1
                  3
                  4
                ];
              };
              preview = {
                max_width = 1600;
                max_height = 2000;
              };
              opener.play = [
                {
                  run = "mpv %s";
                  orphan = true;
                  for = "unix";
                }
              ];
            };
          };
          fastfetch.settings = {
            enable = true;
            logo = {
              padding.top = 4;
              width = 32;
              type = "kitty-direct";
              source = pkgs.fetchurl {
                url = "https://github.com/user-attachments/assets/0e1a77ac-6739-4153-bd24-abd3a5e143f5";
                sha256 = "qptveLRd16pnbuGxQbKduNG6TiDroy84pcO3nPC68UM=";
              };
            };

            modules = [
              "title"
              "separator"
              "os"
              "host"
              "kernel"
              "uptime"
              "shell"
              "display"
              "de"
              "wm"
              "wmtheme"
              "theme"
              "icons"
              "font"
              "cursor"
              "terminal"
              "terminalfont"
              "cpu"
              "gpu"
              "memory"
              "swap"
              "disk"
              "localip"
              "battery"
              "poweradapter"
              "locale"
              "break"
              "colors"
            ];
          };

          home-manager.enable = true;
        };
      };
    };
  };
}
