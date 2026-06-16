{
  config,
  inputs,
  ...
}: let
  targetSystem = "aarch64-darwin";

  sharedSpecialArgs = {
    inherit inputs;
    inherit (config) vars;
  };

  reginaAspects = with config.flake.modules.darwin; [
    common
    desktop
    home
    darwin-desktop
    inputs.determinate.darwinModules.default
  ];

  reginaInline = {
    networking.hostName = "regina";
    networking.computerName = "regina";

    homebrew = {
      onActivation.cleanup = "zap";
      taps = [
        "Sikarugir-App/sikarugir"
      ];
      brews = [
        "argp-standalone"
      ];
      casks = [
        "helium-browser"
        "yubico-authenticator"
        "gimp"
        "inkscape"
        "openmw"
        "openttd"
        "steam"
        "windows-app"
        "Sikarugir-App/sikarugir/sikarugir"
        "qgis"
      ];
    };
  };

  reginaModules = reginaAspects ++ [reginaInline];
in {
  flake.darwinConfigurations.regina = inputs.nix-darwin.lib.darwinSystem {
    system = targetSystem;
    modules = reginaModules;

    specialArgs = sharedSpecialArgs;
  };
}
