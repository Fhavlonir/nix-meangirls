{
  flake.modules.nixos.domoticz = {config, ...}: {
    config = {
      portRequests.home = true;
      services = {
        avahi.enable = true;
        matterjs-server = {
          enable = true;
          listenAddress = "0.0.0.0";
          openFirewall = true;
        };
        openthread-border-router = {
          enable = true;
          backboneInterfaces = ["enu1u1"];
          radio = {
            device = "/dev/serial/by-id/usb-Nabu_Casa_ZBT-2_E072A1FA640C-if00";
            baudRate = 460800;
            flowControl = false;
          };
          rest = {
            listenAddress = "0.0.0.0";
            listenPort = 8081;
          };
          web.enable = false;
        };
        domoticz = {
          enable = true;
          port = config.ports.home;
        };
      };
    };
  };
}
