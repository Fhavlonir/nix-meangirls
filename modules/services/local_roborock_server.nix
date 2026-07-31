_: {}
#_: {
#  flake.modules.nixos.roborock = {
#    config,
#    lib,
#    pkgs,
#    ...
#  }: let
#    local_roborock_server = pkgs.buildPythonPackage rec {
#      pname = "local_roborock_server";
#      version = "07db179510d6c29ce89d80becf4b0ad29ff7782d";
#      format = "pyproject";
#
#      src = pkgs.fetchFromGitHub {
#        owner = "Python-roborock";
#        repo = "local_roborock_server";
#        rev = "07db179510d6c29ce89d80becf4b0ad29ff7782d";
#        sha256 = "";
#      };
#
#      doCheck = false;
#
#      meta = {
#        description = "Self-hosted server for roborock vacuum cleaners";
#        homepage = "https://github.com/Python-roborock/local_roborock_server";
#        license = lib.licenses.mit;
#      };
#    };
#  in {
#    services.local_roborock_server = {
#      enable = true;
#      package = local_roborock_server;
#      plugins = plugins:
#        with plugins; [
#        ];
#      extraConfig = {
#      };
#    };
#
#    environment.systemPackages = [
#      local_roborock_server
#    ];
#  };
#}
