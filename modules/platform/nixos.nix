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
    security.run0.enableSudoAlias = true;
    securiyy.run0.wheelNeedsPassword = false;
    security.sudo.enable = false;
  };
}
