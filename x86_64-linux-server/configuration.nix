{
  config,
  lib,
  pkgs,
  age,
  ...
}: let
  hostName = "pvgj";
  domain = "se";
  fqdn = hostName + "." + domain;
  userName = "philip.johansson";
  ntfy-port = "8081";
  #portunus-port = 8083;
  age.secrets.molly_vapid_privkey_env.file = ../secrets/molly_vapid_privkey_env.age;
in {
  imports = [
    ./disk-config.nix
  ];
  config = {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
    };
    #nixpkgs.overlays = [
    #  (
    #    self: super: {
    #      dbus = super.dbus.override {
    #        systemdMinimal = self.systemd;
    #      };
    #    }
    #  )
    #];

    environment.systemPackages = with pkgs;
      map lib.lowPrio [
        libarchive
        abduco
        gdu
      ];
    services = {
      udev.enable = false;
      lvm.enable = false;

      openssh.enable = true;

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          ${fqdn} = {
            forceSSL = true;
            enableACME = true;
            root = "/var/www/${fqdn}";
          };
          "vw.${fqdn}" = {
            enableACME = true;
          };
          "ldap.${fqdn}" = {
            forceSSL = true;
            enableACME = true;
            locations."/".proxyPass = "http://127.0.0.1:8080";
          };
          "ntfy.${fqdn}" = {
            forceSSL = true;
            enableACME = true;
            locations."/".proxyPass = "http://127.0.0.1:${ntfy-port}";
          };
        };
      };

      portunus = {
        enable = true;
        domain = "ldap.${fqdn}";
        #port = "${portunus-port}";
        ldap = {
          suffix = "dc=${hostName},dc=${domain}";
        };
      };
      radicale = {
        enable = true;
        settings.auth = {
          type = "ldap";
        };
      };
      vaultwarden = {
        enable = true;
        domain = "vw.${fqdn}";
        configureNginx = true;
      };
      mollysocket = {
        enable = true;
        environmentFile = config.age.secrets.molly_vapid_privkey_env.path;
        settings.allowed_endpoints = ["https://ntfy.${fqdn}"];
      };
      ntfy-sh = {
        settings.listen-http = ":${ntfy-port}";
        settings.base-url = "https://ntfy.${fqdn}";
        enable = true;
      };
      ejabberd.enable = true;
    };

    programs = {
      vim.enable = true;
      fish.enable = true;
      git.enable = true;
      yazi = {
        enable = true;
      };
    };

    users.groups.nginx.members = ["openldap"];
    users.users = {
      ${userName} = {
        isNormalUser = true;
        extraGroups = ["netdev" "wheel" "video"];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBHSzJ1EcGdQvX9prWihek5S+Wm68jrQRrazJFfFU2pUJdFPpcsAKkvYgH1giKcMGy18G6S3LB9y3NNg+z83FrqQAAAAEc3NoOg== ${userName}@synotio.se"
        ];
      };
      root.openssh.authorizedKeys.keys = [
        "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBHSzJ1EcGdQvX9prWihek5S+Wm68jrQRrazJFfFU2pUJdFPpcsAKkvYgH1giKcMGy18G6S3LB9y3NNg+z83FrqQAAAAEc3NoOg== ${userName}@synotio.se"
      ];
    };

    networking = {
      inherit hostName;
      inherit domain;
      firewall.allowedTCPPorts = [22 80 443];
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

    security = {
      sudo.extraRules = [
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
      #sudo.enable = false; # Soon, Lennart willing...
      #run0 = {
      #  wheelNeedsPassword = false;
      #  enableSudoAlias = true;
      #};
      acme = {
        acceptTerms = true;
        defaults = {
          email = "${userName}@synotio.se";
        };
      };
    };
    nix = {
      gc = {
        automatic = true;
        options = "--delete-old";
      };
      settings.auto-optimise-store = true;
      settings.experimental-features = ["nix-command" "flakes"];
    };
    system.stateVersion = "25.11";
  };
}
