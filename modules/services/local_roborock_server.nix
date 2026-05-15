{...}: {
  flake.modules.nixos.roborock = {
    config,
    lib,
    pkgs,
    ...
  }: let
    local_roborock_server = pkgs.buildPythonPackage rec {
      pname = "local_roborock_server";
      version = "07db179510d6c29ce89d80becf4b0ad29ff7782d";
      format = "pyproject";

      src = pkgs.fetchFromGitHub {
        owner = "Python-roborock";
        repo = "local_roborock_server";
        rev = "07db179510d6c29ce89d80becf4b0ad29ff7782d";
        sha256 = "";
      };

      doCheck = false;

      meta = {
        description = "Self-hosted server for roborock vacuum cleaners";
        homepage = "https://github.com/Python-roborock/local_roborock_server";
        license = lib.licenses.mit;
      };
    };
    #octoprint-notify = pkgs.writeShellApplication {
    #  name = "octoprint-notify";
    #  runtimeInputs = with pkgs; [
    #    curl
    #  ];
    #  text = ''
    #    export AWS_SHARED_CREDENTIALS_FILE="${config.sops.templates."octoprint/aws-credentials".path}"
    #    exec ${../../scripts/octoprint-notify.sh} "$@"
    #  '';
    #};
  in {
    services.octoprint = {
      enable = true;
      package = local_roborock_server;
      plugins = plugins:
        with plugins; [
        ];
      extraConfig = {
      };
    };

    services.go2rtc = {
      enable = true;
    };

    environment.systemPackages = [
      #octoprint-notify
    ];
  };
}
