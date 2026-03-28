{
  config,
  lib,
  pkgs,
  ...
}: let
  hostName = "pvgj";
  domain = "se";
  fqdn = hostName + "." + domain;
  userName = "philip.johansson";
  ntfy-port = "8081";
in {
  imports = [
    ./disk-config.nix
  ];
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
        "vault.${fqdn}" = {
          enableACME = true;
        };
        "ntfy.${fqdn}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${ntfy-port}";
            proxyWebsockets = true; # needed if you need to use WebSocket
          };
        };
      };
    };

    openldap = {
      enable = true;

      /*
      enable plain and secure connections
      */
      urlList = ["ldap:///" "ldaps:///"];

      settings = {
        attrs = {
          olcLogLevel = "conns config";

          /*
          settings for acme ssl
          */
          olcTLSCACertificateFile = "/var/lib/acme/${fqdn}/full.pem";
          olcTLSCertificateFile = "/var/lib/acme/${fqdn}/cert.pem";
          olcTLSCertificateKeyFile = "/var/lib/acme/${fqdn}/key.pem";
          #olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
          olcTLSCRLCheck = "none";
          olcTLSVerifyClient = "never";
          olcTLSProtocolMin = "3.1";
        };

        children = {
          "cn=schema".includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          ];

          "olcDatabase={1}mdb".attrs = {
            objectClass = ["olcDatabaseConfig" "olcMdbConfig"];

            olcDatabase = "{1}mdb";
            olcDbDirectory = "/var/lib/openldap/data";

            olcSuffix = "dc=${hostName},dc=${domain}";

            olcRootDN = "cn=admin,dc=${hostName},dc=${domain}";
            olcRootPW.path = pkgs.writeText "olcRootPW" "{SSHA}QAPZjDbgz0UUrt/lYwE43jA24WPCeXE6";

            olcAccess = [
              /*
              custom access rules for userPassword attributes
              */
              ''                {0}to attrs=userPassword
                                by self write
                                by anonymous auth
                                by * none''

              /*
              allow read on anything else
              */
              ''                {1}to *
                                by * read''
            ];
          };
        };
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
      domain = "vault.${fqdn}";
      configureNginx = true;
    };
    mollysocket = {
      enable = true;
    };
    ntfy-sh = {
      settings.listen-http = "0.0.0.0:${ntfy-port}";
      settings.base-url = "https://ntfy.${fqdn}";
      enable = true;
    };
    ejabberd.enable = true;
  };

  programs = {
    vim.enable = true;
    #tmux.enable = true;
    fish.enable = true;
    git.enable = true;
    #yazi = {
    #  enable = true;
    #};
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
}
