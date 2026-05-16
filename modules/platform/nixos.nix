{
  config,
  lib,
  ...
}: let
  inherit (config) vars;
in {
  flake.modules.nixos.desktop = _: {
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
