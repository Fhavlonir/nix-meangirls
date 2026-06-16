_: {
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
          settings.APP_KEY_FILE = "/var/lib/firefly-iii/keyfile";
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
      systemd.services.firefly-iii-key-file = {
        description = "Generate Firefly III key file";

        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "firefly-iii";
          User = "firefly-iii";
          Group = "nginx";
        };

        script = ''
          set -eu
          if [ ! -f /var/lib/firefly-iii/keyfile ]; then
            cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 > /var/lib/firefly-iii/keyfile
            chmod 0400 /var/lib/firefly-iii/keyfile
          fi
        '';
      };
    };
  };
}
