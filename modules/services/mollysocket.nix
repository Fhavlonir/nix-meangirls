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
      #systemd.services.mollysocket-vapid-init = {
      #  description = "Generate MollySocket VAPID key";

      #  before = ["mollysocket.service"];
      #  wantedBy = ["multi-user.target"];

      #  serviceConfig = {
      #    Type = "oneshot";
      #    RemainAfterExit = true;
      #    StateDirectory = "mollysocket";
      #    User = "root";
      #    Group = "root";
      #  };

      #  script = ''
      #    set -eu
      #    if [ ! -s /var/lib/mollysocket/env ]; then
      #      echo "MOLLY_VAPID_PRIVKEY=$(${pkgs.mollysocket}/bin/mollysocket vapid gen)" > /var/lib/mollysocket/env
      #      chmod 0400 /var/lib/mollysocket/env
      #    fi
      #  '';
      #};

      #systemd.services.mollysocket = {
      #  after = ["mollysocket-vapid-init.service"];
      #  requires = ["mollysocket-vapid-init.service"];
      #};
    };
  };
}
