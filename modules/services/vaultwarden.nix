_: {
  flake.modules.nixos.vaultwarden = {config, ...}: {
    config = {
      portRequests.vw = true;
      services.vaultwarden = {
        enable = true;
        domain = "vw.${config.networking.fqdn}";
        config.rocketPort = config.ports.vw;
      };
    };
  };
}
