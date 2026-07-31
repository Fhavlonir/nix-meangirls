_: {
  flake.modules.nixos.unbound = _: {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = ["0.0.0.0" "::0"];
          access-control = [
            "127.0.0.0/8 allow"
            "::1 allow"
            "192.168.0.0/16 allow"
          ];
          local-data = [
            "\"gretchen.pvgj.se. IN A 192.168.0.2\""
            "\"api-roborock.pvgj.se. IN A 192.168.0.2\""
            "\"home.pvgj.se. IN A 192.168.0.2\""
            "\"otbr.pvgj.se. IN A 192.168.0.2\""
          ];
        };

        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "1.1.1.1"
            ];
          }
        ];
      };
    };
  };
}
