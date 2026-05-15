{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.firefox = {
    pkgs,
    lib,
    ...
  }: {
    programs.firefox = {
      enable = true;
      profiles."philip.johansson" = {
        settings = {
          "browser.ml.chat.enabled" = false;
          "browser.uidensity" = 1;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.usage.uploadEnabled" = false;
          "dom.security.https_only_mode" = true;
          "extensions.autoDisableScopes" = 0;
          "privacy.trackingprotection.enabled" = true;
          "signon.rememberSignons" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
        };
        search.default = "ddg";
        extensions.packages = with inputs.firefox-addons.packages."aarch64-darwin"; [
          bitwarden
          ublock-origin
          sponsorblock
          darkreader
          reddit-enhancement-suite
        ];
        #extensions.settings."uBlock@raymondhill.net".settings = {
        #  selectedFilterLists = [
        #    "ublock-filters"
        #    "ublock-badware"
        #    "ublock-privacy"
        #    "ublock-unbreak"
        #    "ublock-quick-fixes"
        #  ];
        #};
      };
    };
  };
}
