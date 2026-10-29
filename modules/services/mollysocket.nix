{
  flake.modules.nixos.mollysocket = {
    config,
    pkgs,
    ...
  }: {
    config = {
      portRequests.molly = true;
      requestedSecrets.molly-vapid = {
        consumers = ["mollysocket"];
        command = ''echo "MOLLY_VAPID_PRIVKEY=$(${pkgs.mollysocket}/bin/mollysocket vapid gen)"'';
      };
      services.mollysocket = {
        enable = true;
        environmentFile = config.generatedSecrets.molly-vapid.path;
        settings = {
          allowed_endpoints = ["https://ntfy.${config.networking.fqdn}"];
          port = config.ports.molly;
        };
      };
    };
  };
}
