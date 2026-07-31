_: {
  flake.modules.nixos.roborock = {
    config,
    lib,
    pkgs,
    ...
  }: let
    python = pkgs.python3Packages;
    #python-roborock-4 = python.buildPythonPackage rec {
    #  pname = "python-roborock";
    #  version = "4.20.0";

    #  # fetchPypi or fetchFromGitHub...

    #  dependencies = [];
    #};
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

      dependencies = with python; [
        aiohttp
        cryptography
        fastapi
        gmpy2
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

    format = pkgs.formats.toml {};

    configFile = format.generate "roborock-config.toml" (
      lib.recursiveUpdate
      {
        network = {
          stack_fqdn = "api-roborock.${config.networking.fqdn}";
          bind_host = "0.0.0.0";
          https_port = config.ports.api-roborock;
          advertised_https_port = 443;
          mqtt_tls_port = 8881;
          advertised_mqtt_tls_port = 8881;
          listener_mode = "external_tls";
        };

        storage = {
          data_dir = "/var/lib/roborock";
        };

        broker = {
          mode = "external";
          host = "127.0.0.1";
          port = 1883;
        };
        tls = {
          mode = "provided";
        };
        admin = {
          password_hash = "pbkdf2_sha256$600000$replace_me$replace_me";
          session_secret = "replace-with-at-least-24-random-characters";
          session_ttl_seconds = 86400;
          protocol_auth_enabled = true;
          new_connections_enabled = true;
          # Home Assistant/app logins use this email plus a local 6-digit PIN entered as the "code".
          protocol_login_email = "philip.johansson@synotio.se";
          protocol_login_pin_hash = "pbkdf2_sha256$600000$replace_me$replace_me";
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
      #services.nginx.virtualHosts."roborock-api.${config.networking.fqdn}" = {
      #  enableACME = false;
      #  forceSSL = false;
      #};
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
