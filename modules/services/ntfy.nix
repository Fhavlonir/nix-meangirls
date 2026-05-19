_: {
  flake.modules.nixos.ntfy = {config, ...}: {
    config = {
      portRequests.ntfy = true;
      services = {
        ntfy-sh = {
          enable = true;
          settings = {
            listen-http = ":${toString config.ports.ntfy}";
            base-url = "https://ntfy.${config.networking.fqdn}";
          };
        };
      };
    };
  };
}
