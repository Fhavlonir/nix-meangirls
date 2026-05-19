_: {
  flake.modules.nixos.radicale = {pkgs, ...}: {
    services.radicale = {
      enable = true;
    };
  };
}
