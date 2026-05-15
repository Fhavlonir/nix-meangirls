_: {
  flake.modules.nixos.ntfy = {
    self,
    pkgs,
    ...
  }: let
    ntfy-url = "ntfy.${self.config.networking.hostname}";
  in {
    services.ntfy-sh = {
      settings = {
        listen-http = ":${toString self.config.nginx.virtualHosts.${ntfy-url}.port}";
        base-url = "https://${ntfy-url}";
      };
      enable = true;
    };
  };
}
