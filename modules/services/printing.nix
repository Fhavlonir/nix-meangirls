{
  flake.modules.nixos.printing = {
    config,
    pkgs,
    ...
  }: {
    config = {
      fonts.packages = [pkgs.dejavu_fonts];
      services = {
        avahi = {
          enable = true;
          nssmdns4 = true; # for IPv4 (use nssmdns6 for IPv6)
          openFirewall = true;
          publish = {
            enable = true;
            userServices = true;
          };
        };
        printing = {
          listenAddresses = ["*:631"];
          allowFrom = ["all"];
          browsing = true;
          defaultShared = true;
          openFirewall = true;
          enable = true;
          drivers = with pkgs; [
            hplip
          ];
        };
        #ipp-usb.enable = true;
        samba = {
          enable = true;
          package = pkgs.sambaFull;
          openFirewall = true;
          settings = {
            "global" = {
              "load printers" = "yes";
              "printing" = "cups";
              "printcap name" = "cups";
            };
            "printers" = {
              "comment" = "All Printers";
              "path" = "/var/spool/samba";
              "public" = "yes";
              "browseable" = "yes";
              # to allow user 'guest account' to print.
              "guest ok" = "yes";
              "writable" = "no";
              "printable" = "yes";
              "create mode" = 0700;
            };
          };
        };
      };
      systemd.tmpfiles.rules = [
        "d /var/spool/samba 1777 root root -"
      ];
    };
  };
}
