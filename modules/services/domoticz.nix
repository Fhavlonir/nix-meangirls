_: {
  flake.modules.nixos.domoticz = {config, ...}: {
    config = {
      portRequests = {
        home = true;
        #otbr = true;
      };
      services = {
        #nginx.virtualHosts."home.${config.networking.fqdn}" = {
        #  enableACME = false;
        #  forceSSL = false;
        #};
        #nginx.virtualHosts."otbr.${config.networking.fqdn}" = {
        #  enableACME = false;
        #  forceSSL = false;
        #};
        avahi.enable = true;
        matterjs-server = {
          enable = true;
          listenAddress = "0.0.0.0";
          openFirewall = true;
          #extraArgs = ["--primary-interface enu1u1"];
        };
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
            listenAddress = "0.0.0.0"; # Defaults to 127.0.0.1

            # It is recommended to use port 8081 as some web UI features do not work
            # with a different port
            listenPort = 8081;
          };
          web = {
            enable = true; # enables the basic web interface

            listenAddress = "0.0.0.0"; # defaults to 127.0.0.1
            #listenPort = config.ports.otbr; # this port can be altered freely
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
        domoticz = {
          enable = true;
          port = config.ports.home;
        };
      };
    };
  };
}
