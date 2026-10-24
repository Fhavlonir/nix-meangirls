{
  flake.modules.nixos.ldap = {config, ...}: {
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
              password.from_command = ["cat" config.generatedSecrets.portunus-root.path];
            }
            {
              login_name = "philip";
              given_name = "Philip";
              family_name = "Johansson";
              password.from_command = ["cat" config.generatedSecrets.portunus-philip.path];
            }
            {
              login_name = "radicale";
              given_name = "Radical";
              family_name = "E";
              password.from_command = ["cat" config.generatedSecrets.portunus-radicale.path];
            }
          ];
        };
      };
      requestedSecrets = {
        portunus-root = {
          owner = config.services.portunus.user;
          consumers = ["portunus"];
        };
        portunus-philip = {
          owner = config.services.portunus.user;
          consumers = ["portunus"];
        };
        portunus-radicale = {
          owner = config.services.portunus.user;
          consumers = ["portunus" "radicale"];
        };
      };
    };
  };
}
