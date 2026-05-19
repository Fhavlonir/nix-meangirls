_: {
  flake.modules.nixos.mollysocket = {
    config,
    pkgs,
    ...
  }: {
    config = {
      portRequests.molly = true;
      services.mollysocket = {
        enable = true;
        environmentFile = "/var/lib/mollysocket/env";
        settings = {
          allowed_endpoints = ["https://ntfy.${config.networking.fqdn}"];
          port = config.ports.molly;
        };
      };
      systemd.services.mollysocket-vapid-init = {
        description = "Generate MollySocket VAPID key";

        before = ["mollysocket.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "mollysocket";
          User = "root";
          Group = "root";
        };

        script = ''
          set -eu
          if [ ! -f /var/lib/mollysocket/env ]; then
            echo "MOLLY_VAPID_PRIVKEY=$(${pkgs.mollysocket}/bin/mollysocket vapid gen)" > /var/lib/mollysocket/env
            #chmod 744 /var/lib/mollysocket/env
          fi
        '';
      };

      systemd.services.mollysocket = {
        after = ["mollysocket-vapid-init.service"];
        requires = ["mollysocket-vapid-init.service"];
      };
    };
  };
}
