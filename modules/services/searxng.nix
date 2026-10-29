{
  flake.modules.nixos.search = {config, ...}: {
    config = {
      portRequests.search = true;
      services = {
        searx = {
          limiterSettings = {
            real_ip = {
              x_for = 1;
              ipv4_prefix = 32;
              ipv6_prefix = 56;
            };
            botdetection.ip_lists.block_ip = [
            ];
          };

          enable = true;
          redisCreateLocally = true;
          environmentFile = config.generatedSecrets.searx-secret-key.path;
          settings.server = {
            limiter = true;
            port = config.ports.search;
            server.secret_key = "$SEARX_SECRET_KEY";
          };
        };
      };
      requestedSecrets = {
        searx-secret-key = {
          consumers = ["searx"];
          command = ''echo "SEARX_SECRET_KEY=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)"'';
        };
      };
    };
  };
}
