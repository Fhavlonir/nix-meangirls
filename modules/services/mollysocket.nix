_: {
  flake.modules.nixos.mollysocket = {pkgs, ...}: {
    services.mollysocket = {
      enable = true;
    };
  };
}
