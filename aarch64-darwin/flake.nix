{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:yaxitech/ragenix";
  };

  outputs = inputs @ {
    firefox-addons,
    home-manager,
    nix-darwin,
    nixpkgs,
    nvf,
    self,
    stylix,
    agenix,
    ...
  }: let
    configuration = {pkgs, ...}: {
      networking.hostName = "ONK1WKS9";
      nix.enable = false;
      users.users."philip.johansson".home = "/Users/philip.johansson";
      system = {
        configurationRevision = self.rev or self.dirtyRev or null;
        stateVersion = 6;
        primaryUser = "philip.johansson";
      };
      services.openssh.enable = false;
      security.pam.services.sudo_local.touchIdAuth = true;
      launchd.daemons."sysctl-vram-limit" = {
        command = "/usr/sbin/sysctl iogpu.wired_limit_mb=115200";
        serviceConfig.RunAtLoad = true;
      };
      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        brews = [
          "mpd"
          #"percona-server"
        ];
        casks = [
          "gimp"
          "inkscape"
          "openmw"
          "openttd"
          "steam"
          "windows-app"
          "Sikarugir-App/sikarugir/sikarugir"
        ];
      };
      nix.settings = {
        experimental-features = "nix-command flakes";
        download-buffer-size = 524288000;
      };
      services.yabai = {
        enable = true;
        config = {
          focus_follows_mouse = "autoraise";
          layout = "bsp";
          auto_balance = "on";
          left_padding = 10;
          right_padding = 10;
          top_padding = 10;
          bottom_padding = 10;
          window_gap = 10;
        };
      };
      nixpkgs.config = {
        allowUnfree = true;
        #allowUnsupportedSystemm = true;
      };
      environment.systemPackages = with pkgs; [
        #fjord.outputs.packages.aarch64-darwin.fjordlauncher
        audacity
        firefox
        ghostty-bin
        mpv
        signal-desktop
        thunderbird
        vlc-bin
        wireguard-tools
      ];
    };
  in {
    darwinConfigurations."ONK1WKS9" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            sharedModules = [
              nvf.homeManagerModules.default
              stylix.homeModules.stylix
              agenix.homeManagerModules.default
            ];
            extraSpecialArgs = {inherit inputs;};
            users."philip.johansson" = ./ONK1WKS9-home.nix;
          };
        }
      ];
    };
  };
}
