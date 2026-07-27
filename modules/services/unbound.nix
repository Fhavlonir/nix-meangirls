_: {
  flake.modules.nixos.unbound = _: {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = ["0.0.0.0"];
        };
        forward-zone = [
          {
            name = ".";
            forward-addr = "1.1.1.1@853#cloudflare-dns.com";
          }
          {
            name = "example.org.";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"
            ];
          }
        ];
        remote-control.control-enable = true;
      };
    };
  };
}
