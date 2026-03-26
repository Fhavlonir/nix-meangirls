{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = with pkgs;
    map lib.lowPrio [
      libarchive
    ];

  services = {
    openssh.enable = true;
    openldap.enable = true;
    radicale.enable = true;
    vaultwarden.enable = true;
    ntfy-sh.enable = true;
    nginx.enable = true;
    ejabberd.enable = true;
  };

  programs = {
    vim.enable = true;
    tmux.enable = true;
    fish.enable = true;
    git.enable = true;
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  users.users = {
    philip.johansson = {
      isNormalUser = true;
      extraGroups = ["netdev" "wheel" "video"];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBHSzJ1EcGdQvX9prWihek5S+Wm68jrQRrazJFfFU2pUJdFPpcsAKkvYgH1giKcMGy18G6S3LB9y3NNg+z83FrqQAAAAEc3NoOg== philip.johansson@synotio.se"
      ];
    };
    root.openssh.authorizedKeys.keys = [
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBHSzJ1EcGdQvX9prWihek5S+Wm68jrQRrazJFfFU2pUJdFPpcsAKkvYgH1giKcMGy18G6S3LB9y3NNg+z83FrqQAAAAEc3NoOg== philip.johansson@synotio.se"
    ];
  };

  networking = {
    hostname = "pvgj.se";
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
