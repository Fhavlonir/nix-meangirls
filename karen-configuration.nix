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

  nix.settings.substituters = ["https://cuda-maintainers.cachix.org"];
  boot = {
    #kernelPackages = pkgs.linuxPackages_cachyos;
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

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia-container-toolkit.enable = true;

  services = {
    openssh.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
            set -gx EDITOR nvim
            direnv hook fish | source
            set fish_greeting "Cady: You're not stupid, Karen.
        Karen: No. I am, actually. I'm failing almost everything.
        Cady: Well, there must be something you're good at.
        Karen: I can put my whole fist in my mouth. Wanna see?
        Cady: No. That's OK. Anything else?
        Karen: I'm kind of psychic. I have a fifth sense.
        Cady: What do you mean?
        Karen: It's like I have ESPN or something. My breasts can always tell when it's gonna rain.
        Cady: Really? That's amazing.
        Karen: Well, they can tell when it's raining."
      '';
    };
    sway.enable = true;
  };

  environment.systemPackages = with pkgs; [
    blender
    #fjordlauncher
    nvtopPackages.full
    openmw
    portmod
    libreoffice
    renderdoc
    toolbox
    vim
  ];

  system.stateVersion = "24.11";
}
