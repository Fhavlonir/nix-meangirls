{
  config,
  lib,
  ...
}: let
  inherit (config) vars;

  commonPackages = pkgs:
    with pkgs; [
      git
      curl
    ];

  commonBase = pkgs: {
    environment.systemPackages = commonPackages pkgs;

    environment.variables.EDITOR = "nvim";

    users.users.${vars.username}.openssh.authorizedKeys.keys = vars.sshAuthorizedKeys;

    time.timeZone = "Europe/Stockholm";
    programs.fish.enable = true;
  };
in {
  flake.modules.nixos.common = {pkgs, ...}: {
    config = lib.mkMerge [
      (commonBase pkgs)
      {
        nix.settings = {
          trusted-users = [
            "@wheel"
            vars.username
          ];
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
        };
        nix.gc.automatic = true;

        users.users.${vars.username} = {
          description = vars.fullName;
          isNormalUser = true;
          extraGroups = ["wheel" "video"];
          shell = pkgs.fish;
        };

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
          };
        };
        environment.shells = [pkgs.fish];
        boot.kernelPackages = pkgs.linuxPackages_latest;
        security = {
          run0 = {
            enable = true;
            enableSudoAlias = true;
            wheelNeedsPassword = false;
          };
          sudo.enable = false;
          polkit.enable = true;
        };
      }
    ];
  };

  flake.modules.darwin.common = {
    pkgs,
    lib,
    ...
  }: {
    imports = [];

    config = lib.mkMerge [
      (commonBase pkgs)
      {
        environment.systemPackages = with pkgs; [
          m-cli
          python3
        ];

        users.users.${vars.username} = {
          home = "/Users/${vars.username}";
        };

        environment.shells = [pkgs.fish];
      }
    ];
  };
}
