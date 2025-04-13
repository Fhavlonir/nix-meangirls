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

  networking.hostName = "regina-george"; # Define your hostname.
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
    sway.enable = true;
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

  environment.systemPackages = with pkgs; [
    fuzzel
    grim # screenshot functionality
    i3status-rust
    ladybird
    mako # notification system developed by swaywm maintainer
    poweralertd
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wol # wake-on-lan
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
