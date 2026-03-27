{
  lib,
  pkgs,
  ...
}: let
  hostName = "pvgj";
  domain = "se";
  fqdn = hostName + "." + domain;
in {
  imports = [
    ./disk-config.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };
  nixpkgs.overlays = [
    (
      self: super: {
        dbus = super.dbus.override {
          systemdMinimal = self.systemd;
        };
      }
    )
  ];

  environment.systemPackages = with pkgs;
    map lib.lowPrio [
      libarchive
      abduco
    ];
  services = {
    udev.enable = false;
    lvm.enable = false;

    openssh.enable = true;
    openldap.enable = true;
    radicale = {
      enable = true;
      settings.auth.type = "denyall";
    };
    vaultwarden = {
      enable = true;
      domain = fqdn;
    };
    ntfy-sh = {
      settings.base-url = fqdn;
      enable = true;
    };
    nginx.enable = true;
    ejabberd.enable = true;
  };

  programs = {
    vim.enable = true;
    #tmux.enable = true;
    fish.enable = true;
    git.enable = true;
    yazi = {
      enable = true;
    };
  };

  users.users = {
    "philip.johansson" = {
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
    inherit hostName;
    inherit domain;
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
  security.sudo.extraRules = [
    {
      users = ["philip.johansson"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
  nix = {
    gc = {
      automatic = true;
      options = "--delete-old";
    };
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };
  system.stateVersion = "25.11";
}
