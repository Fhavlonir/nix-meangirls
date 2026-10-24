{
  config,
  lib,
  ...
}: let
  inherit (config) vars;
in {
  flake.modules.nixos.homepage = {
    config,
    pkgs,
    ...
  }: let
    serviceNames = lib.attrNames config.portRequests;

    links =
      lib.concatMapStrings (name: ''
        <li><a href="https://${name}.${config.networking.fqdn}">${name}</a></li>
      '')
      serviceNames;

    html = ''
      <!DOCTYPE html>
      <html>
      <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>${vars.fullName}</title>
          <style>
              body {
                  background-color: #959595;
              }
          </style>
      </head>
      <body>
          <h1>Hello, I am ${vars.fullName}</h1>
          <ul>
              ${links}
          </ul>
      </body>
      </html>
    '';

    webroot = pkgs.runCommand "webroot" {} ''
      mkdir -p $out
      cp ${pkgs.writeText "index.html" html} $out/index.html
    '';
  in {
    services.nginx.virtualHosts."${config.networking.fqdn}" = {
      root = webroot;
      forceSSL = true;
      enableACME = true;
    };
  };
}
