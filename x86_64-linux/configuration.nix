{
  lib,
  pkgs,
  ...
}: let
  # r-with-my-packages = pkgs.rstudioWrapper.override{  packages = with pkgs; [
  #     #parallel
  #     conda
  #     rPackages.MASS
  #     rPackages.MLeval
  #     rPackages.caret
  #     rPackages.doParallel
  #     rPackages.foreach
  #     rPackages.gbm
  #     rPackages.ggparty
  #     rPackages.glmnet
  #     rPackages.kernlab
  #     rPackages.magick
  #     rPackages.mda
  #     rPackages.partykit
  #     rPackages.purrr
  #     rPackages.rJavaEnv
  #     rPackages.randomForest
  #     rPackages.ranger
  #     rPackages.reticulate
  #     rPackages.rpart #.plot
  #     rPackages.text
  #     rPackages.torch
  #     rPackages.rTorch
  #     rPackages.torchdatasets
  #     rPackages.torchvision
  #   ];};
in {
  imports = [
    ../vim.nix
  ];

  boot = {
    plymouth.enable = true;
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 4;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["bcachefs"];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];

  security.polkit.enable = true;
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Stockholm";
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "C.UTF-8";
  console = {
    keyMap = "sv-latin1";
  };

  services = {
    deluge.enable = true;
    getty.autologinUser = "philip";
    printing.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
    pcscd.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  users.users.philip = {
    isNormalUser = true;
    extraGroups = ["netdev" "wheel" "video"];
  };

  programs = {
    ssh.startAgent = false;
    ssh.extraConfig = "SetEnv TERM=xterm-256color";
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    firefox.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -gx EDITOR nvim
        direnv hook fish | source
      '';
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    light.enable = true;
    sway.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin vkbasalt vkbasalt-cli mangohud];
    };
    bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };

  systemd.oomd.enable = true;
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      DISPLAY = ":0";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  environment.systemPackages = with pkgs; [
    #r-with-my-packages
    ananicy-cpp
    ananicy-rules-cachyos
    bat
    bottles
    btop
    cachix
    calibre
    duf
    dust
    erlang
    fastfetch
    fd
    feh
    ffmpeg
    fish
    freerdp
    fuzzel
    gdu
    gimp3
    git
    glsl_analyzer
    grim # screenshot functionality
    gurk-rs
    htop
    i3status-rust
    imagemagick
    inetutils
    inkscape
    jdk
    jq
    killall
    kitty
    libarchive
    marp-cli
    mpv
    openttd
    pandoc
    pavucontrol
    peazip
    poweralertd
    ripgrep
    signal-desktop-bin
    tealdeer # tldr but in rust
    texliveSmall
    tmux
    unp
    vim
    vimPlugins.nvim-treesitter-parsers.glsl
    wineWowPackages.waylandFull
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wireguard-tools
    wol # wake-on-lan
    yazi
    yt-dlp
    zathura
  ];

  fonts.packages = with pkgs;
    [
      fira-math
      fira-code
      noto-fonts
      noto-fonts-cjk-sans
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nix.gc = {
    automatic = true;
    options = "--delete-old";
  };
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.11";
}
