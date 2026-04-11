{
  self,
  inputs,
  ...
}: {
  flake.pvgj-configuration = {
    config,
    pkgs,
    lib,
    ...
  }: let
    userName = "philip.johansson";
    ntfy-port = 8081;
    radicale-port = 8082;
    portunus-port = 8083;
  in {
    config = {
      age.rekey = {
        hostPubkey = "pvgj.se ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILY+gq6LfgwJLPZgyRu55dtjsk3woqhHf8ifcjdA1zS";
        masterIdentities = ["${self}/secrets/identities/yubikey-identity.pub"];
        storageMode = "local";
        localStorageDir = "${self}/secrets/rekeyed/${config.networking.hostName}";
      };
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
            ${config.networking.fqdn} = {
              forceSSL = true;
              enableACME = true;
              root = "/var/www/${config.networking.fqdn}";
            };
            "vw.${config.networking.fqdn}" = {
              enableACME = true;
            };
            "dav.${config.networking.fqdn}" = {
              forceSSL = true;
              enableACME = true;
              locations."/".proxyPass = "http://127.0.0.1:${toString radicale-port}";
            };
            "ldap.${config.networking.fqdn}" = {
              forceSSL = true;
              enableACME = true;
              locations."/".proxyPass = "http://127.0.0.1:${toString portunus-port}";
            };
            "ntfy.${config.networking.fqdn}" = {
              forceSSL = true;
              enableACME = true;
              locations."/".proxyPass = "http://127.0.0.1:${toString ntfy-port}";
            };
          };
        };

        portunus = {
          enable = true;
          domain = "ldap.${config.networking.fqdn}";
          port = portunus-port;
          ldap = {
            suffix = "dc=${config.networking.hostName},dc=${config.networking.domain}";
          };
          seedSettings = {
            groups = [
              {
                name = "admin-team";
                long_name = "Admin Team";
                members = ["root"];
                permissions = {
                  portunus.is_admin = true;
                  ldap.can_read = true;
                };
                posix_gid = 101;
              }
            ];
            users = [
              {
                login_name = "root";
                given_name = "Mr.";
                family_name = "root";
                password.from_command = ["cat" "/home/${userName}/admin-pw.txt"]; #config.age.secrets.ldap_root_pw.path];
              }
              {
                login_name = "p";
                given_name = "Philip";
                family_name = "Johansson";
                #password.from_command = ["cat" config.age.secrets.ldap_user_pw.path];
                #posix = { # posix_uid error wtf?
                #  inherit (config.users.groups."${config.users.users.${userName}.group}") gid;
                #  inherit (config.users.users.${userName}) home;
                #  inherit (config.users.users.${userName}) uid;
                #};
              }
            ];
          };
        };
        radicale = {
          enable = true;
          settings = {
            server.hosts = ["0.0.0.0:${toString radicale-port}"];
            auth = {
              type = "ldap";
              ldap_reader_dn = "uid=root,ou=users,dc=${config.networking.hostName},dc=${config.networking.domain}";
              ldap_base = "dc=${config.networking.hostName},dc=${config.networking.domain}";
              ldap_secret_file = "/home/${userName}/admin-pw.txt"; #config.age.secrets.ldap_root_pw.path;
            };
          };
        };
        vaultwarden = {
          enable = true;
          domain = "vw.${config.networking.fqdn}";
          configureNginx = true;
        };
        mollysocket = {
          enable = true;
          #environmentFile = config.age.secrets.molly_vapid_privkey_env.path;
          settings.allowed_endpoints = ["https://ntfy.${config.networking.fqdn}"];
        };
        ntfy-sh = {
          settings.listen-http = ":${toString ntfy-port}";
          settings.base-url = "https://ntfy.${config.networking.fqdn}";
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
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICVYhZcVj1ZjwMNiaZAjyzrqo2wGVe6bVXddBNEivhldAAAABHNzaDo= philip.johansson@synotio.se"
          ];
      };

      networking = {
        hostName = "pvgj";
        domain = "se";
        firewall.allowedTCPPorts = [22 80 443];
        enableIPv6 = false;
        useNetworkd = true;
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
            users = [userName];
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
  };
}
