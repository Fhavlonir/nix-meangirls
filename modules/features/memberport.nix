{
  self,
  inputs,
  ...
}: {
  flake.memberport = {
    pkgs,
    lib,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem {
      services = {
        postgres.enable = true;
        rabbitmq.enable = true;
        mailhog.enable = true;
      };
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          kratos
          (python313.withPackages (
            p:
              with p; [
                aiosmtplib
                asyncpg
                bleach
                celery
                pytz
                tinycss2
                tornado
              ]
          ))
        ];
      };
    };
}
