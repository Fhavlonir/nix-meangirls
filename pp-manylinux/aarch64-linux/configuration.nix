{
  lib,
  pkgs,
  ...
}: {
  #boot = {
  #  loader = {
  #    timeout = 1;
  #    systemd-boot.enable = true;
  #    systemd-boot.configurationLimit = 4;
  #    efi.canTouchEfiVariables = true;
  #  };
  #};

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];

  security.polkit.enable = true;
  #nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "C.UTF-8";
  console = {
    keyMap = "sv-latin1";
  };

  users.users.philip.johansson = {
    isNormalUser = true;
    extraGroups = ["netdev" "wheel"];
  };

  programs = {
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        direnv hook fish | source
      '';
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
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

  environment.systemPackages = with pkgs; [
    ananicy-cpp
    bat
    btop
    cachix
    duf
    dust
    fastfetch
    fd
    fish
    gdu
    git
    htop
    inetutils
    jq
    killall
    ghostty
    libarchive
    ripgrep
    tmux
    unp
    vim
    yazi
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-old";
  };
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "25.05";
}
