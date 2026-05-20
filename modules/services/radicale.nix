_: {
  flake.modules.nixos.radicale = {
    pkgs,
    config,
    ...
  }: {
    portRequests.dav = true;
    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = ["0.0.0.0:${toString config.ports.dav}" "[::]:${toString config.ports.dav}"];
        };
        auth = {
          type = "ldap";
          ldap_base = config.services.portunus.ldap.suffix;
          ldap_reader_dn = "uid=radicale,ou=users,${config.services.portunus.ldap.suffix}";
          ldap_secret_file = "/var/lib/portunus/radicale";
          ldap_filter = "(uid={0})";
        };
        #storage = {
        #  filesystem_folder = "/var/lib/radicale/collections";
        #};
      };
    };
  };
}
