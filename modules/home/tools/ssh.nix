{
  flake.modules.homeManager.ssh = {pkgs, ...}: {
    programs.ssh = {
      enable = true;
      package = pkgs.openssh;
      enableDefaultConfig = false;
      extraConfig = "SetEnv TERM=xterm-256color";
      settings."*" = {
        forwardAgent = true;
        compression = true;
      };
    };
  };
}
