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
    desktop
    common
    home
    unbound
    port-assign
    nginx
    domoticz
    roborock
    printing
    #inputs.determinate.nixosModules.default
    #inputs.nixos-hardware.nixosModules.raspberry-pi-3
    #(inputs.nixpkgs.outPath + "/nixos/modules/profiles/minimal.nix")
    #(inputs.nixpkgs.outPath + "/nixos/modules/profiles/headless.nix")
  ];

  gretchenInline = {
    networking = {
      hostName = "gretchen";
      fqdn = "pvgj.se";
      firewall.allowedTCPPorts = [22 80 443 555 1883 5580 8881 8883];
      firewall.allowedUDPPorts = [53];

      nameservers = ["9.9.9.9" "1.1.1.1"];
      useNetworkd = true;

      #networkmanager.enable = true;
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
      #initrd.availableKernelModules = [
      #  "xhci_pci"
      #  "usbhid"
      #];
      #initrd.kernelModules = [];
      kernelModules = ["usblp"];
      #extraModulePackages = [];
      loader.grub.enable = false;
      loader.generic-extlinux-compatible.enable = true;
    };

    fileSystems."/" = {
      device = "/dev/mmcblk0p2";
      fsType = "ext4";
    };

    #fileSystems."/boot/firmware" = {
    #  device = "/dev/mmcblk0p1";
    #  fsType = "vfat";
    #  options = ["fmask=0022" "dmask=0022"];
    #};
    #hardware.raspberry-pi.firmware = {
    #  enable = true;
    #  uboot.enable = true;
    #};

    swapDevices = [];
  };

  gretchenModules = gretchenAspects ++ [gretchenInline];
in {
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
      targetUser = "philip.johansson";
    };
  };
}
