_: {
  flake.modules.nixos.port-assign = {
    lib,
    config,
    ...
  }: {
    options.portRequests = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = {};
      description = "Request auto-allocated ports for services";
    };

    options.ports = lib.mkOption {
      type = lib.types.attrsOf lib.types.port;
      description = "Auto-allocated port assignments";
    };

    config = {
      ports = lib.mkDefault (
        let
          basePort = 3000;
          portReqs = lib.filterAttrs (_: v: v) config.portRequests;
          serviceNames = lib.attrNames portReqs;
          assignPorts = lib.foldl' (acc: name:
            acc
            // {
              ${name} = acc.nextPort;
              nextPort = acc.nextPort + 1;
            }) {nextPort = basePort;} (lib.sort (a: b: a < b) serviceNames);
        in
          lib.filterAttrs (k: _: k != "nextPort") assignPorts
      );
      services.nginx.virtualHosts = lib.mapAttrs' (name: port:
        lib.nameValuePair
        "${name}.${config.networking.fqdn}"
        {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        })
      config.ports;
    };
  };
}
