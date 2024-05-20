{
  documentation.man = {
    generateCaches = true;
    man-db.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };
}
