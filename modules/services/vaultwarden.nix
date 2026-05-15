_: {
  flake.modules.nixos.vaultwarden = {pkgs, ...}: {
    services.vaultwarden = {
      enable = true;
    };
  };
}
