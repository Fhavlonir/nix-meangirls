# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  stylix,
  ...
}: {
  imports = [
    ./karen-hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    supportedFilesystems = ["bcachefs"];
  };
  virtualisation.containers.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  networking.hostName = "karen-smith"; # Define your hostname.
  networking.interfaces.enp4s0.wakeOnLan.enable = true;
  networking.firewall = {
    allowedUDPPorts = [22];
    allowedTCPPorts = [22];
  };

  #environment.gnome.excludePackages = with pkgs; [
  #  atomix # puzzle game
  #  cheese # webcam toolgnome-browser-connector                              (command link)
  #  gnome-calculator
  #  gnome-calendar
  #  gnome-clocks
  #  gnome-connections
  #  gnome-contacts
  #  gnome-maps
  #  epiphany # web browser
  #  evince # document viewer
  #  geary # email reader
  #  gedit # text editor
  #  gnome-characters
  #  gnome-music
  #  gnome-photos
  #  gnome-terminal
  #  gnome-tour
  #  gnome-weather
  #  gnome-text-editor
  #  gnome-system-monitor
  #  hitori # sudoku game
  #  iagno # go game
  #  tali # poker game
  #  totem # video player
  #];

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia-container-toolkit.enable = true;

  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
    };
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
            set -gx EDITOR nvim
            direnv hook fish | source
            set fish_greeting "
        Cady: You're not stupid, Karen.
        Karen: No. I am, actually. I'm failing almost everything.
        Cady: Well, there must be something you're good at.
        Karen: I can put my whole fist in my mouth. Wanna see?
        Cady: No. That's OK. Anything else?
        Karen: I'm kind of psychic. I have a sixth sense.
        Cady: What do you mean?
        Karen: It's like I have ESPN or something. My breasts can always tell when it's gonna rain.
        Cady: Really? That's amazing.
        Karen: Well, they can tell when it's raining.
            "
      '';
      #loginShellInit = ''
      #  if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
      #    exec sway --unsupported-gpu
      #  end
      #'';
    };
    sway.enable = true;
  };

  environment.systemPackages = with pkgs; [
    blender
    nvtopPackages.full
    openmw
    portmod
    toolbox
    vim
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
