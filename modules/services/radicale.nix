_: {
  flake.modules.nixos.ntfy = {pkgs, ...}: {
    services.ntfy = {
      enable = true;
    };
  };
}
