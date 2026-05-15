_: {
  flake.modules.nixos.port-assign = {
    self,
    pkgs,
    ...
  }: let
    inherit (pkgs.lib) mkOption types;
    requests = self.config.portRequests;
    basePort = 3000;

    # Get all service names requesting ports
    serviceNames = pkgs.lib.attrNames requests;

    # Assign ports sequentially
    assignPorts =
      pkgs.lib.foldl'
      (acc: name:
        acc
        // {
          ${name} = acc.nextPort;
          nextPort = acc.nextPort + 1;
        })
      {nextPort = basePort;}
      (pkgs.lib.sort (a: b: a < b) serviceNames);

    portMap = pkgs.lib.filterAttrs (k: _: k != "nextPort") assignPorts;
  in {
    self.options.portRequests = mkOption {
      type = types.attrsOf types.bool;
      default = {};
      description = "Request auto-allocated ports for services";
    };

    self.options.ports = mkOption {
      type = types.attrsOf types.port;
      default = portMap;
      readOnly = true;
      description = "Auto-allocated port assignments";
    };
  };
}
