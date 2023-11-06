{ me, pkgs, ... }:

{
  home-manager.users.${me} = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg.enableGnomeExtensions = true;
        extraPolicies = {
          DisableFirefoxStudies = true;
          DisableSetDesktopBackground = true;
          DisableTelemetry = true;
          DNSOverHTTPS = {
            Enabled = true;
            ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
            Locked = true;
            ExcludedDomains = [ ];
          };
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
            Exceptions = [ ];
          };
          NoDefaultBookmarks = true;
        };
      };
      profiles = {
        default = {
          id = 0;
          name = "default";
        };
      };
    };
  };
}
