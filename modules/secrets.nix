{
  flake.modules.nixos.generated-secrets = {
    lib,
    config,
    pkgs,
    ...
  }: let
    dir = "/var/lib/generated-secrets";
    unit = name: "generate-secret-${name}";

    units = name: s:
      {
        ${unit name} = {
          description = "Generate secret ${name}";
          wantedBy = ["multi-user.target"];
          path = [pkgs.coreutils];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            StateDirectory = "generated-secrets";
            StateDirectoryMode = "0711"; # owners other than root must reach their file
          };
          script = ''
            set -eu
            umask 077
            [ -s ${dir}/${name} ] && exit 0
            tmp=$(mktemp ${dir}/${name}.XXXXXX)
            trap 'rm -f "$tmp"' EXIT
            tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 > "$tmp"
            [ "$(stat -c %s "$tmp")" = 32 ]
            chown ${s.owner} "$tmp"
            chmod 0400 "$tmp"
            mv "$tmp" ${dir}/${name}
          '';
        };
      }
      // lib.genAttrs s.consumers (_: {
        requires = ["${unit name}.service"];
        after = ["${unit name}.service"];
        serviceConfig.LoadCredential = ["${name}:${dir}/${name}"];
      });
  in {
    options = {
      requestedSecrets = lib.mkOption {
        default = {};
        description = "Secrets to generate on this machine on first boot.";
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            consumers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [];
              description = "Services (without .service) that use this secret.";
            };
            owner = lib.mkOption {
              type = lib.types.str;
              default = "root";
              description = "Owner of the file, for services that read it directly.";
            };
          };
        });
      };

      generatedSecrets = lib.mkOption {
        description = "Where each requested secret can be read.";
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            path = lib.mkOption {type = lib.types.externalPath;};
            credentials = lib.mkOption {type = lib.types.attrsOf lib.types.externalPath;};
          };
        });
      };
    };

    config = {
      generatedSecrets =
        lib.mapAttrs (name: s: {
          path = "${dir}/${name}";
          credentials = lib.genAttrs s.consumers (c: "/run/credentials/${c}.service/${name}");
        })
        config.requestedSecrets;

      systemd.services = lib.mkMerge (lib.mapAttrsToList units config.requestedSecrets);
    };
  };
}
