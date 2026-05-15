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
  };
}
