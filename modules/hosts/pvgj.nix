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
  ];

  pvgjInline = {
    networking = {
      hostName = "pvgj";
      domain = "se";
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
      device = "/dev/disk/by-uuid/ca62a5da-087c-4ef5-8c49-c3b02a2bf677";
      fsType = "btrfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/E4BC-9DF2";
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
