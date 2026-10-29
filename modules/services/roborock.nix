{
  flake.modules.nixos.roborock = {
    config,
    lib,
    pkgs,
    ...
  }: let
    python = pkgs.python313Packages;
    roborock-local-server = python.buildPythonPackage rec {
      pname = "roborock-local-server";
      version = "1.2.1";

      src = pkgs.fetchFromGitHub {
        owner = "python-roborock";
        repo = "local_roborock_server";
        rev = "v${version}";
        sha256 = "hscJr2Z217dTKaeR2PihZucqwV1lKO6q2KMYgZuap2w=";
      };

      pyproject = true;

      nativeBuildInputs = with python; [
        hatchling
        pythonRelaxDepsHook
      ];

      pythonRelaxDeps = [
        "cryptography"
        "gmpy2"
        "python-roborock"
      ];

      dependencies = with python; [
        aiohttp
        cryptography
        fastapi
        gmpy2
        python-multipart
        pycryptodome
        python-roborock
        uvicorn
      ];
      meta = {
        description = "Private local Roborock server stack";
        homepage = "https://github.com/python-roborock/local_roborock_server";
        license = pkgs.lib.licenses.mit;
        mainProgram = "roborock-local-server";
      };
    };

    cfg = config.services.roborock;

    hashFile = pkgs.writeScript "roborock-hash-file" ''
      #!${python.python.withPackages (_: [roborock-local-server])}/bin/python3
      import sys
      from roborock_local_server.security import hash_password

      with open(sys.argv[1]) as f:
          print(hash_password(f.read().strip("\n")))
    '';

    format = pkgs.formats.toml {};

    configFile = format.generate "roborock-config.toml" (
      lib.recursiveUpdate
      {
        network = {
          stack_fqdn = "api-roborock.${config.networking.fqdn}";
          bind_host = "127.0.0.1";
          https_port = config.ports.api-roborock;
          mqtt_tls_port = 8881;
          advertised_https_port = 443;
          advertised_mqtt_tls_port = 8883;
          listener_mode = "external_tls";
        };

        storage = {
          data_dir = "/var/lib/roborock";
        };

        broker = {
          mode = "external";
          host = "127.0.0.1";
          port = 1883;
          mosquitto_binary = "${pkgs.mosquitto}/bin/mosquitto";
          enable_topic_bridge = true;
        };
        tls = {
          mode = "provided";
        };
        admin = {
          password_hash = "@ADMIN_HASH@";
          session_secret = "@SESSION_SECRET@";
          session_ttl_seconds = 86400;
          protocol_auth_enabled = true;
          new_connections_enabled = false;
          protocol_login_email = "hello@${config.networking.fqdn}";
          protocol_login_pin_hash = "@PIN_HASH@";
        };
      }
      cfg.settings
    );
  in {
    options.services.roborock = {
      settings = lib.mkOption {
        inherit (format) type;
        default = {};

        description = ''
          Raw local_roborock_server TOML configuration.

          This maps directly to upstream config.toml.
        '';
      };
    };

    config = {
      portRequests.api-roborock = true;
      requestedSecrets = {
        roborock-session.consumers = ["roborock"];
        roborock-admin-password.consumers = ["roborock"];
        roborock-pin = {
          consumers = ["roborock"];
          length = 6;
          charset = "0-9";
        };
      };
      users.users.roborock = {
        isSystemUser = true;
        group = "roborock";
        description = "Local Roborock server user";
      };

      users.groups.roborock = {};

      environment.systemPackages = [
        roborock-local-server
      ];

      services = {
        mosquitto = {
          enable = true;

          listeners = [
            {
              address = "127.0.0.1";
              port = 1883;

              settings = {
                allow_anonymous = true;
              };

              omitPasswordAuth = true;
              acl = [
                "topic readwrite #"
                "pattern readwrite #"
              ];
            }
          ];
        };

        nginx.streamConfig = ''
          server {
            listen 8883 ssl;
            ssl_certificate     /var/lib/acme/api-roborock.${config.networking.fqdn}/fullchain.pem;
            ssl_certificate_key /var/lib/acme/api-roborock.${config.networking.fqdn}/key.pem;
            proxy_pass 127.0.0.1:8881;
          }
        '';
      };

      systemd.services.roborock = {
        description = "Local Roborock server";

        wantedBy = [
          "multi-user.target"
        ];

        after = [
          "network-online.target"
          "mosquitto.service"
        ];

        wants = [
          "network-online.target"
          "mosquitto.service"
        ];

        serviceConfig = {
          User = "roborock";
          Group = "roborock";

          StateDirectory = "roborock";

          ExecStart = ''
            ${roborock-local-server}/bin/roborock-local-server \
              serve \
              --config /var/lib/roborock/config.toml
          '';

          Restart = "on-failure";
        };

        preStart = let
          rs = lib.getExe pkgs.replace-secret;
          conf = "/var/lib/roborock/config.toml";
          secret = name: config.generatedSecrets.${name}.credentials.roborock;
        in ''
          install -m 0600 ${configFile} ${conf}

          ${rs} @SESSION_SECRET@ ${secret "roborock-session"} ${conf}

          tmp=$(mktemp)
          trap 'rm -f "$tmp"' EXIT
          ${hashFile} ${secret "roborock-admin-password"} > "$tmp"
          ${rs} @ADMIN_HASH@ "$tmp" ${conf}
          ${hashFile} ${secret "roborock-pin"} > "$tmp"
          ${rs} @PIN_HASH@ "$tmp" ${conf}

          # replace-secret silently does nothing when a placeholder is missing,
          # and "! grep" would not trip set -e, so test explicitly.
          if grep -qE '@[A-Z_]+@' ${conf}; then
            echo "unreplaced placeholder left in ${conf}" >&2
            exit 1
          fi
        '';
      };
    };
  };
}
