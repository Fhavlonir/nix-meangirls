{
  flake.modules.nixos.roborock = {
    config,
    lib,
    pkgs,
    ...
  }: let
    python = pkgs.python3Packages;
    roborock-local-server = python.buildPythonPackage rec {
      pname = "roborock-local-server";
      version = "1.0.2";

      src = pkgs.fetchFromGitHub {
        owner = "python-roborock";
        repo = "local_roborock_server";
        rev = "v${version}";
        hash = "sha256-/NkezHJEUKdZ6I5L96g50rLlHccfHXYct/0LO+RNqOU=";
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

      dependencies = [
        python.aiohttp
        python.cryptography
        python.fastapi
        python.gmpy2
        python.pycryptodome
        python.python-roborock
        python.uvicorn
      ];
      #postPatch = ''
      #  substituteInPlace src/roborock_local_server/server.py \
      #    --replace-fail \
      #      '    def _start_mqtt_proxy(self) -> None:' \
      #      '    def _start_mqtt_proxy(self) -> None:
      #          self.runtime_state.set_service(
      #              "mqtt_tls_proxy",
      #              running=False,
      #              required=True,
      #              enabled=False,
      #          )
      #          return'
      #'';

      meta = {
        description = "Private local Roborock server stack";
        homepage = "https://github.com/python-roborock/local_roborock_server";
        license = pkgs.lib.licenses.mit;
        mainProgram = "roborock-local-server";
      };
    };

    cfg = config.services.roborock;

    format = pkgs.formats.toml {};

    configFile = format.generate "roborock-config.toml" (
      lib.recursiveUpdate
      {
        network = {
          stack_fqdn = "api-roborock.${config.networking.fqdn}";
          bind_host = "0.0.0.0";
          https_port = config.ports.api-roborock;
          advertised_https_port = 443;
          #mqtt_tls_port = 8881;
          advertised_mqtt_tls_port = 8883;
          listener_mode = "external_tls";
        };

        storage = {
          data_dir = "/var/lib/roborock";
        };

        broker = {
          mode = "external";
          #host = "api-roborock.${config.networking.fqdn}";
          #port = 8883;
          host = "127.0.0.1";
          port = 1883;
          mosquitto_binary = "${pkgs.mosquitto}/bin/mosquitto";
        };
        tls = {
          mode = "provided";
        };
        admin = {
          password_hash = "pbkdf2_sha256$600000$-vJQlapDkx-W9Xht_3V4Cg$_c0TOkaYnOEa9LqtqK3WSPjYBR9DudlZIiNgnlQCY1U";
          session_secret = "ObVmAuD7miSIvoxTgc9WYK8V";
          session_ttl_seconds = 86400;
          protocol_auth_enabled = false;
          new_connections_enabled = true;
          protocol_login_email = "hello@${config.networking.fqdn}";
          protocol_login_pin_hash = "pbkdf2_sha256$600000$-vJQlapDkx-W9Xht_3V4Cg$_c0TOkaYnOEa9LqtqK3WSPjYBR9DudlZIiNgnlQCY1U";
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
          logType = ["all"];

          listeners = [
            {
              address = "127.0.0.1";
              port = 1883;

              settings = {
                #connection_messages = true;
                allow_anonymous = true;
              };

              omitPasswordAuth = true;
              #acl = [
              #  "pattern readwrite #"
              #];
            }
          ];
        };

        nginx.streamConfig = lib.mkForce ''
          server {
            listen 8883 ssl;
            ssl_certificate     /var/lib/acme/api-roborock.${config.networking.fqdn}/fullchain.pem;
            ssl_certificate_key /var/lib/acme/api-roborock.${config.networking.fqdn}/key.pem;
            proxy_pass 127.0.0.1:1883;
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
        ];

        wants = [
          "network-online.target"
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

        preStart = ''
          install -m 0640 \
            -o roborock \
            -g roborock \
            ${configFile} \
            /var/lib/roborock/config.toml
        '';
      };
    };
  };
}
