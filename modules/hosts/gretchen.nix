{
  config,
  inputs,
  ...
}: let
  targetSystem = "aarch64-linux";

  sharedSpecialArgs = {
    inherit inputs;
    inherit (config) vars;
  };

  gretchenAspects = with config.flake.modules.nixos; [
    common
    home
    unbound
    port-assign
    generated-secrets
    nginx
    domoticz
    roborock
    printing
  ];

  gretchenInline = {
    networking = {
      hostName = "gretchen";
      fqdn = "pvgj.se";
      firewall.allowedTCPPorts = [22 53 80 443 8881 8883];
      firewall.allowedUDPPorts = [53];

      nameservers = ["9.9.9.9" "1.1.1.1"];
      useNetworkd = true;

      interfaces.enu1u1.ipv4.addresses = [
        {
          address = "192.168.0.2";
          prefixLength = 24;
        }
      ];
      defaultGateway = {
        address = "192.168.0.1";
        interface = "enu1u1";
      };
    };
    boot = {
      kernelModules = ["usblp"];
      loader.grub.enable = false;
      loader.generic-extlinux-compatible.enable = true;
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    system.stateVersion = "25.11";

    swapDevices = [];
  };

  gretchenModules = gretchenAspects ++ [gretchenInline];
in {
  colmenaNodeSystems.gretchen = targetSystem;
  flake.nixosConfigurations.gretchen = inputs.nixpkgs.lib.nixosSystem {
    system = targetSystem;
    modules = gretchenModules;

    specialArgs = sharedSpecialArgs;
  };
  flake.colmena.gretchen = {
    imports = gretchenModules;

    deployment = {
      privilegeEscalationCommand = ["run0"];
      targetHost = "192.168.0.2";
      targetUser = config.vars.username;
    };
  };
}
