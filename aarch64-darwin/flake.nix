{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    #fjord.url = "path:/Users/philip.johansson/Development/FjordLauncher";
    #fjord.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf/v0.8";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    firefox-addons,
    #fjord,
    home-manager,
    nix-darwin,
    nixpkgs,
    nvf,
    self,
    stylix,
  }: let
    #homebrew = {
    #  enable = true;
    #  onActivation.cleanup = "zap";
    #  taps = [
    #    "gcenx/homebrew-wine"
    #  ];
    #  brews=["game-porting-toolkit"];
    #}
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
      #security.pam.loginLimits = [
      #  {
      #    domain = "*";
      #    type = "soft";
      #    item = "nofile";
      #    value = "8192";
      #  }
      #];
      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";
        brews = [
          "mpd"
          "percona-server"
        ];
        casks = [
          "amethyst"
          "gimp"
          "inkscape"
          "openmw"
          "openttd"
          "steam"
          "windows-app"
        ];
      };
      nix.settings = {
        experimental-features = "nix-command flakes";
        download-buffer-size = 524288000;
      };
      #services.yabai = {
      #  enable = true;
      #  config = {
      #    focus_follows_mouse = "autoraise";
      #    layout = "bsp";
      #    auto_balance = "on";
      #    left_padding = 10;
      #    right_padding = 10;
      #    top_padding = 10;
      #    bottom_padding = 10;
      #    window_gap = 10;
      #  };
      #};
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        #fjord.outputs.packages.aarch64-darwin.fjordlauncher
        audacity
        bitwarden-desktop
        firefox
        ghostty-bin
        mpv
        openscad
        signal-desktop-bin
        thunderbird
        vlc-bin
        wireguard-tools
        whisky
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
            ];
            extraSpecialArgs = {inherit inputs;};
            users."philip.johansson" = ./ONK1WKS9-home.nix;
          };
        }
      ];
    };
  };
}
