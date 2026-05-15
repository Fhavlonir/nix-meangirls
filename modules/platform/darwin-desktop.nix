{
  config,
  lib,
  ...
}: let
  inherit (config) vars;
in {
  flake.modules.darwin.desktop = _: {
    system = {
      primaryUser = vars.username;
      stateVersion = 6;
    };
    security.pam.services.sudo_local.touchIdAuth = true;
    time.timeZone = "Europe/Stockholm";
  };
}
