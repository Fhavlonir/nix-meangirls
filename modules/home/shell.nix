_: {
  flake.modules.homeManager.shell = {pkgs, ...}: {
    home.packages = [pkgs.fastfetch];
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_user_paths /etc/profiles/per-user/$USER/bin/ssh $fish_user_paths
        direnv hook fish | source
        set fish_greeting
        fastfetch
      '';
    };
  };
}
