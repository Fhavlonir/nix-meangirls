_: {
  flake.modules.nixos.ntfy = {
    self,
    pkgs,
    ...
  }: {
    services.nginx = {
    };
  };
}
