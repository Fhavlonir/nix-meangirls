{inputs, ...}: {
  flake.modules.darwin.darwin-desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      ghostty-bin
      inputs.colmena.outputs.packages.aarch64-darwin.colmena
      macmon
      mpv
      signal-desktop
    ];
  };
}
