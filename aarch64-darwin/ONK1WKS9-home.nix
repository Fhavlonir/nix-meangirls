{
  pkgs,
  inputs,
  ...
}: let
  ghostty-shaders = pkgs.fetchFromGitHub {
    owner = "KroneCorylus";
    repo = "ghostty-shader-playground";
    rev = "b539cea7b34cdc883726db018ae09e8e3f862aea";
    sha256 = "dfk2Ti+T1jEC5M8ijaO1KnfzW6MP5yswovZgoptqO3A=";
  };
in {
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
      audacity
      av1an
      bat
      btop
      curl
      deluge
      duf
      electrum
      exiftool
      fastfetch
      fd
      ffmpeg
      figlet
      gdu
      gitFull
      gitoxide
      graphicsmagick
      imagemagick
      lsd
      mediainfo
      mpv
      ncmpcpp
      nmap
      openscad
      openssh
      oxipng
      pandoc
      pls
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
  imports = [../vim.nix];
  stylix = {
    enable = true;
    autoEnable = false;
    targets = {
      btop.enable = true;
      firefox.enable = true;
      firefox.profileNames = ["philip.johansson"];
      fish.enable = true;
      ghostty.enable = true;
      mpv.enable = true;
      nvf.enable = true;
      yazi.enable = true;
    };
    opacity = {
      terminal = 0.5;
      popups = 0.5;
    };
    fonts = {
      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };
    };
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
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
    firefox = {
      enable = true;
      profiles."philip.johansson" = {
        settings = {
          "browser.ml.chat.enabled" = false;
          "browser.uidensity" = 1;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.usage.uploadEnabled" = false;
          "dom.security.https_only_mode" = true;
          "extensions.autoDisableScopes" = 0;
          "privacy.trackingprotection.enabled" = true;
          "signon.rememberSignons" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
        };
        search.default = "ddg";
        extensions.packages = with inputs.firefox-addons.packages."aarch64-darwin"; [
          bitwarden
          ublock-origin
          sponsorblock
          darkreader
          reddit-enhancement-suite
        ];
        #extensions.settings."uBlock@raymondhill.net".settings = {
        #  selectedFilterLists = [
        #    "ublock-filters"
        #    "ublock-badware"
        #    "ublock-privacy"
        #    "ublock-unbreak"
        #    "ublock-quick-fixes"
        #  ];
        #};
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
    ghostty = {
      enable = true;
      enableFishIntegration = true;
      package = pkgs.ghostty-bin;
      settings = {
        background-blur = true;
        macos-titlebar-style = "hidden";
        custom-shader = "${ghostty-shaders}/shaders/cursor_blaze.glsl";
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
        fastfetch --logo-padding-top 4 --logo-width 32 --kitty-direct ~/.config/fastfetch/logos/nix-darwin.png
      '';
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
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
      };
    };
    home-manager.enable = true;
  };
}
