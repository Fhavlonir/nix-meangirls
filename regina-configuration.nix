{
  config,
  lib,
  pkgs,
  stylix,
  ...
}: {
  imports = [
    ./regina-hardware-configuration.nix
  ];

  boot = {
    supportedFilesystems = ["bcachefs"];
  };

  networking.hostName = "regina-george"; 
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedUDPPorts = [51820];
    checkReversePath = false;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services = {
    getty.autologinUser = "philip";
    blueman.enable = true;
  };

  programs = {
    fish = {
      interactiveShellInit = ''
        set -gx EDITOR nvim
        direnv hook fish | source
        set fish_greeting "Evil takes a human form in Regina George.
        Don't be fooled, because she may seem like your typical selfish, back-stabbing, slut-faced ho-bag.
        But in reality, she is so much more than that.
        She's the queen bee. The star. Those other two are just her little workers."
      '';
      loginShellInit = ''
        if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
          exec sway
        end
      '';
    };
    light.enable = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        brightnessctl
        pulseaudio
        swayidle
        swaylock
        wol
        grim
        i3status-rust
        mako 
        poweralertd
        slurp
        wl-clipboard
      ];
    };
  };

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      DISPLAY = ":0";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; 

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    libva-utils
    libreoffice
    glslviewer
    fuzzel
  ];

  system.stateVersion = "24.11";
}
