{
  home-manager.users.givon = {
    programs.gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableZshIntegration = true;
      pinentryFlavor = "curses";
    };
  };
}
