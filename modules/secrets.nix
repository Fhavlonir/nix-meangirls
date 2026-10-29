{
  flake.modules.nixos.generated-secrets = {
    lib,
    config,
    pkgs,
    ...
  }: let
    dir = "/var/lib/generated-secrets";
    unit = name: "generate-secret-${name}";

    generator = name: s:
      if s.command != null
      then {
        run = ''{ ${s.command}; } > "$tmp"'';
        check = ''[ -s "$tmp" ]'';
      }
      else {
        run = "tr -dc '${s.charset}' < /dev/urandom | head -c ${toString s.length} > \"$tmp\"";
        check = ''[ "$(stat -c %s "$tmp")" = ${toString s.length} ]'';
      };
    units = name: s: let
      gen = generator name s;
    in
      {
        ${unit name} = {
          description = "Generate secret ${name}";
          wantedBy = ["multi-user.target"];
          path = [pkgs.coreutils];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            StateDirectory = "generated-secrets";
          };
          script = ''
            set -eu
            umask 077
            [ -s ${dir}/${name} ] && exit 0
            tmp=$(mktemp ${dir}/${name}.XXXXXX)
            trap 'rm -f "$tmp"' EXIT
            ${gen.run}
            ${gen.check}
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
            length = lib.mkOption {
              type = lib.types.ints.positive;
              default = 32;
              description = "Length of the generated string. Ignored when `command` is set.";
            };
            charset = lib.mkOption {
              type = lib.types.str;
              default = "A-Za-z0-9";
              description = "Characters to draw from, as a tr(1) set. Ignored when `command` is set.";
            };
            command = lib.mkOption {
              type = lib.types.nullOr lib.types.lines;
              default = null;
              description = ''
                Shell fragment whose stdout becomes the secret, for values that
                need a specific format. Reference programs by store path. The
                generator fails if the output is empty.
              '';
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
