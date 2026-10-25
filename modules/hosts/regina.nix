{
  config,
  inputs,
  ...
}: let
  targetSystem = "aarch64-darwin";

  inherit (config) vars;
  sharedSpecialArgs = {
    inherit inputs;
    inherit vars;
  };

  reginaAspects = with config.flake.modules.darwin; [
    common
    home
    darwin-desktop
    inputs.determinate.darwinModules.default
    rftg
  ];

  reginaInline = {
    networking.hostName = "regina";
    networking.computerName = "regina";
    nix.enable = false;
    determinateNix = {
      enable = true;
      customSettings = {
        eval-cores = 0;
        extra-experimental-features = ["parallel-eval"];
        #sandbox = true;
        extra-trusted-users = [vars.username];
        extra-trusted-substituters = ["https://nix-community.cachix.org"];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        builders-use-substitutes = true;
        use-case-hack = false;
      };

      determinateNixd = {
        builder.state = "enabled";
      };
    };

    homebrew = {
      enable = true;
      taps = [
        "Sikarugir-App/sikarugir"
      ];
      brews = [
        "f3"
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
      ];
    };
    system.stateVersion = 6;
    system.primaryUser = vars.username;
    security.pam.services.sudo_local.touchIdAuth = true;
  };

  reginaModules = reginaAspects ++ [reginaInline];
in {
  flake.darwinConfigurations.regina = inputs.nix-darwin.lib.darwinSystem {
    system = targetSystem;
    modules = reginaModules;

    specialArgs = sharedSpecialArgs;
  };
}
