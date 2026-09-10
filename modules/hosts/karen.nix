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

  karenAspects = with config.flake.modules.nixos; [
    desktop
    common
    home
    home-desktop
    nixos-desktop
  ];

  karenInline = {pkgs, ...}: {
    networking.hostName = "regina";

    nixpkgs.config.allowUnfree = true;
    programs = {
      steam.enable = true;
      #mangowc.enable = true;
      sway.enable = true;
    };
    boot = {
      loader.grub.enable = false;
      loader.systemd-boot.enable = true;
      initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      initrd.kernelModules = [];
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };
    fileSystems."/" = {
      device = "UUID=6fd18a9b-e637-45c9-bd8a-e8d2ebabd85f";
      fsType = "bcachefs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/6521-9264";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/e9f091e7-1b10-4894-8ab3-ef14e175d505";}
    ];
    hardware.nvidia = {
      package = pkgs.linuxPackages_latest.nvidiaPackages.legacy_580;
      modesetting.enable = true;
      open = false;
    };

    networking.useDHCP = true;

    #hardware.nvidia-container-toolkit.enable = true;
    time.timeZone = "Europe/Stockholm";
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Select internationalisation properties.
    i18n.defaultLocale = "C.UTF-8";
    console = {
      keyMap = "sv-latin1";
    };

    services = {
      openssh.enable = true;
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
      };
    };
    #hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };

  karenModules = karenAspects ++ [karenInline];
in {
  flake.nixosConfigurations.karen = inputs.nixpkgs.lib.nixosSystem {
    system = targetSystem;
    modules = karenModules;

    specialArgs = sharedSpecialArgs;
  };
}
