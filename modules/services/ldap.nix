_: {
  flake.modules.nixos.ldap = {pkgs, ...}: {
    services.portunus = {
      enable = true;
    };
  };
}
