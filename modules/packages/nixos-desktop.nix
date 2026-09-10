{
  flake.modules.nixos.nixos-desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      mpv
      signal-desktop
    ];
  };
}
