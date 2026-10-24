{
  flake.modules.nixos.firefly-iii = {config, ...}: {
    config = {
      services = {
        firefly-iii-data-importer = {
          enable = true;
          virtualHost = "firefly-importer.${config.networking.fqdn}";
          enableNginx = true;
        };
        firefly-iii = {
          enable = true;
          virtualHost = "firefly.${config.networking.fqdn}";
          enableNginx = true;
          settings.APP_KEY_FILE = config.generatedSecrets.firefly-app-key.credentials.firefly-iii-setup;
        };
        nginx.virtualHosts."firefly.${config.networking.fqdn}" = {
          forceSSL = true;
          enableACME = true;
        };
        nginx.virtualHosts."firefly-importer.${config.networking.fqdn}" = {
          forceSSL = true;
          enableACME = true;
        };
      };
      requestedSecrets.firefly-app-key.consumers = ["firefly-iii-setup"];
    };
  };
}
