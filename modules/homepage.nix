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
    links = toString (map (x: "<li><a href=https://" + x + "." + config.networking.fqdn + ">" + x + "</a></li>") serviceNames);
    list = toString ["<ul>" links "</ul>"];
    head = "<!DOCTYPE html>\n    <html>\n    <head>\n        <meta charset=\"utf-8\">\n        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n        <title>${vars.fullName}</title>\n        <style>body {background-color: #959595}</style>\n    </head>\n<body>";
    body = "<h1>Hello, I am ${vars.fullName}</h1>";
    webroot = pkgs.stdenv.mkDerivation {
      name = "webroot";

      buildCommand = ''
        mkdir $out
        echo '${head}' > $out/index.html
        echo '${body}' >> $out/index.html
        echo '${list}' >> $out/index.html
        echo '</body></html>' >> $out/index.html
      '';
    };
  in {
    config.services.nginx.virtualHosts."${config.networking.fqdn}" = {
      root = webroot;
      forceSSL = true;
      enableACME = true;
    };
  };
}
