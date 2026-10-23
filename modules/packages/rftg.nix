{moduleWithSystem, ...}: let
  rftgModule = moduleWithSystem (
    {config, ...}: {
      environment.systemPackages = [
        config.packages.rftg
      ];
    }
  );
in {
  perSystem = {pkgs, ...}: {
    packages.rftg = pkgs.stdenv.mkDerivation {
      pname = "rftg";
      version = "0.9.5";

      src = pkgs.fetchFromGitHub {
        owner = "bnordli";
        repo = "rftg";
        rev = "0.9.5";
        hash = "sha256-FI78WKe7/RyL7XmK+vFr6wHjLr6LaRweHNJgieEX5AE=";
      };

      sourceRoot = "source/src";

      nativeBuildInputs = with pkgs; [
        pkg-config
      ];

      buildInputs = with pkgs; [
        gtk2
        gtk-mac-integration-gtk2
      ];

      postPatch = ''
        substituteInPlace gui.c \
          --replace-fail \
            '#include "gtk-mac-menu.h"' \
            '#include <gtkmacintegration/gtkosxapplication.h>'

        substituteInPlace gui.c \
          --replace-fail \
          '	GtkMacMenuGroup *group = gtk_mac_menu_add_app_menu_group();
        	gtk_mac_menu_add_app_menu_item(group,
        	                               GTK_MENU_ITEM(about_item), NULL);

        	group = gtk_mac_menu_add_app_menu_group();
        	gtk_mac_menu_add_app_menu_item(group,
        	                               GTK_MENU_ITEM(option_item),
        	                               "Preferences...");

        	gtk_mac_menu_set_quit_menu_item(GTK_MENU_ITEM(quit_item));

        	gtk_widget_hide(menu_bar);
        	gtk_mac_menu_set_menu_bar(GTK_MENU_SHELL(menu_bar));' \
         'GtkosxApplication *app = gtkosx_application_get();

          gtkosx_application_set_about_item(app, about_item);
          gtkosx_application_insert_app_menu_item(app, option_item, 0);
          gtkosx_application_set_menu_bar(app, GTK_MENU_SHELL(menu_bar));
          gtkosx_application_ready(app);'
      '';

      configurePhase = ''
        ./configure \
          --prefix=$out \
          --disable-server
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp rftg $out/bin/
      '';

      meta = {
        description = "Singleplayer and online implementation of the card game Race for the Galaxy";
        homepage = "http://keldon.net/rftg/";
        mainProgram = "rftg";

        platforms = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ];
      };
    };
  };

  flake.modules.nixos.rftg = rftgModule;
  flake.modules.darwin.rftg = rftgModule;
}
