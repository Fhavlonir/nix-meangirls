_: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    system.stateVersion = "25.11";
    time.timeZone = "Europe/Stockholm";
    programs.fish.enable = true;
    security = {
      run0.enableSudoAlias = true;
      run0.wheelNeedsPassword = false;
      sudo.enable = false;
      polkit.enable = true;
    };
  };
}
