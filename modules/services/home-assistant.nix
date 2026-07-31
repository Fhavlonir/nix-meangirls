_: {
  flake.modules.nixos.home-assistant = {config, ...}: {
    config = {
      portRequests = {
        home = true;
        otbr = true;
      };
      services = {
        nginx.virtualHosts."home.${config.networking.fqdn}" = {
          enableACME = false;
          forceSSL = false;
        };
        nginx.virtualHosts."otbr.${config.networking.fqdn}" = {
          enableACME = false;
          forceSSL = false;
        };
        matter-server.enable = true;
        openthread-border-router = {
          enable = true;
          backboneInterfaces = ["enu1u1"];
          # logLevel = "notice"; controls the log levels
          radio = {
            device = "/dev/serial/by-id/usb-Nabu_Casa_ZBT-2_E072A1FA640C-if00";
            baudRate = 460800; # This and flow control are hardware dependant
            flowControl = false; # check your device's documentation
          };
          rest = {
            listenAddress = "127.0.0.1"; # Defaults to 127.0.0.1

            # It is recommended to use port 8081 as some web UI features do not work
            # with a different port
            listenPort = 8081;
          };
          web = {
            enable = true; # enables the basic web interface

            listenAddress = "0.0.0.0"; # defaults to 127.0.0.1
            listenPort = config.ports.otbr; # this port can be altered freely
          };
        };
        mosquitto = {
          enable = true;
          listeners = [
            {
              acl = ["pattern readwrite #"];
              omitPasswordAuth = true;
              settings.allow_anonymous = true;
            }
          ];
        };
        home-assistant = {
          enable = true;
          extraComponents = [
            # Components required to complete the onboarding
            "analytics"
            "google_translate"
            "met"
            "radio_browser"
            "shopping_list"
            # Mosquitto support
            "mqtt"
            # Components required to operate a matter-over-thread
            # network with home-assistant
            "matter"
            "otbr"
            "thread"
            # Recommended for fast zlib compression
            # https://www.home-assistant.io/integrations/isal
            "isal"
          ];
          config = {
            default_config = {};
            # Includes dependencies for a basic setup
            # https://www.home-assistant.io/integrations/default_config/
            #default_config = {};
            http.server_port = config.ports.home;
            http = {
              server_host = "127.0.0.1";
              trusted_proxies = ["127.0.0.1"];
              use_x_forwarded_for = true;
            };
          };
        };
      };
    };
  };
}
