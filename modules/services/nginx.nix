{config, ...}: {
  flake.modules.nixos.nginx = {
    security.acme = {
      acceptTerms = true;
      defaults = {inherit (config.vars) email;};
    };
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  };
}
