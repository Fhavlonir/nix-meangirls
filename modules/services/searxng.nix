_: {
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
              # "93.184.216.34" # example.org
            ];
          };

          enable = true;
          redisCreateLocally = true;
          settings.server = {
            port = config.ports.search;
            secret_key = "notverysecret";
          };
        };
      };
    };
  };
}
