{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../vim.nix
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = with pkgs;
    map lib.lowPrio [
      cachix
      fish
      git
      libarchive
      tmux
      yazi
    ];

  users.users = {
    philip = {
      isNormalUser = true;
      extraGroups = ["netdev" "wheel" "video"];
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGkEBI7OQog0iiGSE65K4gCFk+W7crC/3m1fK83Hvr6yAAAABHNzaDo= philip.johansson@synotio.se"
      ];
    };
    root.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGkEBI7OQog0iiGSE65K4gCFk+W7crC/3m1fK83Hvr6yAAAABHNzaDo= philip.johansson@synotio.se"
    ];
  };

  networking = {
    enableIPv6 = false;
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
          address = "10.0.0.0";
          prefixLength = 8;
          via = "10.24.68.1";
        }
        {
          address = "10.24.112.0";
          prefixLength = 24;
          via = "10.24.168.1";
        }
      ];
    };
    interfaces.ens224 = {
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
  nix.gc = {
    automatic = true;
    options = "--delete-old";
  };
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "25.11";
}
