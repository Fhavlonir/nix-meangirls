{
  self,
  inputs,
  ...
}: {
  flake.pvgj-hardware-configuration = {lib, ...}: {
    boot = {
      initrd.availableKernelModules = ["ata_piix" "ahci" "vmw_pvscsi" "sd_mod" "sr_mod"];
      initrd.kernelModules = ["dm-snapshot"];
      kernelModules = [];
      extraModulePackages = [];
    };

    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.ens192.useDHCP = lib.mkDefault true;
    # networking.interfaces.ens224.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
