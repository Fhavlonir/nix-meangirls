{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./vim.nix
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
    getty.autologinUser = "philip";
    blueman.enable = true;
    printing.enable = true;
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
    light.enable = true;
    sway.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
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
    ananicy-cpp
    ananicy-rules-cachyos
    btop
    erlang
    erlang-ls
    fastfetch
    feh
    ffmpeg
    fish
    fuzzel
    gdu
    gimp
    git
    glsl_analyzer
    glslviewer
    gnumeric
    grim # screenshot functionality
    gurk-rs
    signal-desktop-bin
    htop
    i3status-rust
    imagemagick
    inetutils
    inkscape
    inkscape-extensions.applytransforms
    jdk
    jq
    killall
    kitty
    libarchive
    mako # notification system developed by swaywm maintainer
    mpv
    pavucontrol
    poweralertd
    slurp # screenshot functionality
    tealdeer # tldr but in rust
    tmux
    vim
    vimPlugins.nvim-treesitter-parsers.glsl
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wol # wake-on-lan
    yazi
    yazi
    yt-dlp
    zathura
  ];

  fonts.packages = with pkgs;
    [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  nix.gc = {
    automatic = true;
    options = "--delete-old";
  };
  nix.settings.auto-optimise-store = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
