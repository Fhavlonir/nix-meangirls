_: {
  flake.modules.nixos.ldap = {
    pkgs,
    config,
    ...
  }: {
    config = {
      portRequests.ldap = true;
      services.portunus = {
        enable = true;
        domain = "ldap.${config.networking.fqdn}";
        port = config.ports.ldap;
        ldap.suffix = "dc=${config.networking.hostName},dc=${config.networking.domain}";
        seedSettings = {
          groups = [
            {
              name = "admin-team";
              long_name = "Admin Team";
              members = ["root"];
              permissions = {
                portunus.is_admin = true;
                ldap.can_read = true;
              };
              posix_gid = 101;
            }
            {
              name = "readers";
              long_name = "Readers group";
              members = ["radicale"];
              permissions = {
                ldap.can_read = true;
              };
            }
          ];
          users = [
            {
              login_name = "root";
              given_name = "Mr.";
              family_name = "root";
              password.from_command = ["cat" "/var/lib/portunus/root"];
            }
            {
              login_name = "philip";
              given_name = "Philip";
              family_name = "Johansson";
              password.from_command = ["cat" "/var/lib/portunus/philip"];
            }
            {
              login_name = "radicale";
              given_name = "Radical";
              family_name = "E";
              password.from_command = ["cat" "/var/lib/portunus/radicale"];
            }
          ];
        };
      };
      systemd.services.ldap-passwords = {
        description = "Generate LDAP passwords";

        before = ["portunus.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "portunus";
          User = "portunus";
          Group = "portunus";
        };

        script = ''
          set -eu
          if [ ! -f /var/lib/portunus/root ]; then
            cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 30 > /var/lib/portunus/root
            chmod 0400 /var/lib/portunus/root
          fi
          if [ ! -f /var/lib/portunus/philip ]; then
            cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 30 > /var/lib/portunus/philip
          fi
          if [ ! -f /var/lib/portunus/radicale ]; then
            cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 30 > /var/lib/portunus/radicale
          fi
        '';
      };

      systemd.services.portunus = {
        after = ["ldap-passwords.service"];
        requires = ["ldap-passwords.service"];
      };
    };
  };
}
