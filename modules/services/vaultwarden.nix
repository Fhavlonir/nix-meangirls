_: {
  flake.modules.nixos.vaultwarden = {
    config,
    pkgs,
    ...
  }: {
    config = {
      portRequests.vaultwarden = true;
      services.vaultwarden = {
        enable = true;
        domain = config.networking.fqdn;
        config.rocketPort = config.ports.vaultwarden;
      };
    };
  };
}
