{
  config,
  inputs,
  ...
}: let
  targetSystem = "x86_64-linux";

  sharedSpecialArgs = {
    inherit inputs;
    inherit (config) vars;
  };

  pvgjAspects = with config.flake.modules.nixos; [
    desktop
    common
    home
    config.flake.modules.generic.ports
  ];

  pvgjInline = {
    networking = {
      hostName = "pvgj";
      domain = "se";
      firewall.allowedTCPPorts = [22 80 443];
      enableIPv6 = true;
      useNetworkd = true;
      nameservers = ["10.24.112.2" "10.24.112.3"];
      interfaces.ens192 = {
        ipv4.addresses = [
          {
            address = "10.24.168.7";
            prefixLength = 24;
          }
        ];
        ipv4.routes = [
          {
            address = "10.24.112.0";
            prefixLength = 24;
            via = "10.24.168.1";
          }
        ];
      };
      interfaces.ens224 = {
        ipv4.routes = [
          {
            address = "10.0.0.0";
            prefixLength = 8;
            via = "10.24.68.1";
          }
        ];
        ipv4.addresses = [
          {
            address = "10.24.68.7";
            prefixLength = 24;
          }
        ];
      };
      defaultGateway = {
        address = "10.24.168.1";
        interface = "ens192";
      };
      useDHCP = false;
    };
    boot = {
      initrd.availableKernelModules = ["ata_piix" "ahci" "vmw_pvscsi" "sd_mod" "sr_mod"];
      initrd.kernelModules = [];

      kernelModules = [];
      extraModulePackages = [];
      loader.grub.enable = false;
      loader.systemd-boot.enable = true;
    };

    fileSystems."/" = {
      device = "/dev/sda2";
      fsType = "bcachefs";
    };

    fileSystems."/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [];
  };

  pvgjModules = pvgjAspects ++ [pvgjInline];
in {
  flake.nixosConfigurations.pvgj = inputs.nixpkgs.lib.nixosSystem {
    system = targetSystem;
    modules = pvgjModules;

    specialArgs = sharedSpecialArgs;
  };
}
