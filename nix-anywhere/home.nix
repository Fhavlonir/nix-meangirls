{
  config,
  pkgs,
  ...
}: {
  home.username = "philip.johansson";
  home.homeDirectory = "/home/philip.johansson";
  home.shellAliases = {
    l = "lsd -lh --tree *";
    ls = "lsd";
    cat = "bat";
  };

  home.packages = with pkgs; [
    bat
    libarchive
    btop
    duf
    fd
    lsd
    gitoxide
    fish
    gdu
    htop
    kitty
    mago
    python3
    ripgrep
    tealdeer
    yazi
    yq
    bat
  ];
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx EDITOR nvim
      direnv hook fish | source
    '';
  };

  home.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:$PATH";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
