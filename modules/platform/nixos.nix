{config, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    system.stateVersion = "25.11";
    time.timeZone = "Europe/Stockholm";
    programs.fish.enable = true;
    security = {
      run0 = {
        enable = true;
        enableSudoAlias = true;
        wheelNeedsPassword = false;
      };
      sudo.enable = false;
      polkit.enable = true;
      acme.acceptTerms = true;
      acme.defaults = {inherit (config.vars) email;};
    };
  };
}
