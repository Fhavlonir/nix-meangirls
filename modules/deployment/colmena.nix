{
  config,
  inputs,
  lib,
  ...
}: {
  options = {
    flake.colmena = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = {};
      description = "Colmena hive configuration merged from host modules.";
    };

    colmenaNodeSystems = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Node to nixpkgs system mapping used to build Colmena nodeNixpkgs.";
    };
  };

  config.flake = {
    colmena.meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
      };
      nodeNixpkgs =
        lib.mapAttrs (
          _: system:
            import inputs.nixpkgs {
              inherit system;
            }
        )
        config.colmenaNodeSystems;
      specialArgs = {
        inherit inputs;
        inherit (config) vars;
      };
    };

    colmenaHive = inputs.colmena.lib.makeHive config.flake.colmena;
  };
}
