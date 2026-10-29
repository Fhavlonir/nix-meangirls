{
  flake.modules.nixos.printing = {pkgs, ...}: {
    config = {
      fonts.packages = [pkgs.dejavu_fonts];
      services = {
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
          settings.publish = {
            disable-publishing = false;
            publish-addresses = true;
            disable-user-service-publishing = false;
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
              "guest ok" = "yes";
              "writable" = "no";
              "printable" = "yes";
              "create mode" = "0700";
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
