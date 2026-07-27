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
    inputs.determinate.nixosModules.default
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
  ];

  gretchenInline = {
    virtualisation.vmware.guest.enable = true;
    networking = {
      hostName = "gretchen";
      firewall.allowedTCPPorts = [22 80 443 555 8881];
      enableIPv6 = true;
      useNetworkd = true;
      useDHCP = true;
    };
    boot = {
      initrd.availableKernelModules = ["usbhid"];
      initrd.kernelModules = [];

      kernelModules = [];
      extraModulePackages = [];
      loader.grub.enable = false;
      loader.generic-extlinux-compatible.enable = true;
      #loader.systemd-boot.enable = true;
    };

    fileSystems."/" = {
      device = "/dev/mmcblk0p2";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/mmcblk0p1";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

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
      #privilegeEscalationCommand = ["run0"];
      targetHost = "192.168.0.175";
      targetUser = "nixos";
      allowLocalDeployment = false;
    };
  };
}
