{
  config,
  lib,
  ...
}: let
  inherit (config) vars;

  commonPackages = pkgs:
    with pkgs; [
      git
      neovim
      curl
      btop
      jq
      ripgrep
      fd
      rsync
    ];

  commonBase = pkgs: {
    environment.systemPackages = commonPackages pkgs;

    environment.variables.EDITOR = lib.mkForce "nvim";

    users.users.${vars.username}.openssh.authorizedKeys.keys = vars.sshAuthorizedKeys;
  };
in {
  # NixOS common base
  flake.modules.nixos.common = {pkgs, ...}:
    lib.mkMerge [
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
        };

        users.users.${vars.username} = {
          isNormalUser = true;
          extraGroups = ["wheel"];
          shell = pkgs.fish;
        };

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
          };
        };
        environment.shells = [pkgs.fish];
      }
    ];

  flake.modules.darwin.common = {
    pkgs,
    lib,
    ...
  }: {
    imports = [];

    config = lib.mkMerge [
      (commonBase pkgs)
      {
        nix = {
          # Determinate Nix owns the daemon.
          enable = false;

          # Workaround: https://github.com/NixOS/nix/issues/7273
          settings.auto-optimise-store = false;

          gc.automatic = false;

          settings = {
            trusted-users = [vars.username];
            substituters = ["https://nix-community.cachix.org"];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
            builders-use-substitutes = true;
          };
        };

        environment.systemPackages = with pkgs; [
          m-cli
          python3
        ];

        users.users.${vars.username} = {
          home = "/Users/${vars.username}";
        };

        #services.openssh = {
        #  enable = true;
        #  extraConfig = ''
        #    PasswordAuthentication no
        #    KbdInteractiveAuthentication no
        #  '';
        #};

        environment.shells = [pkgs.fish];
      }
    ];
  };
}
