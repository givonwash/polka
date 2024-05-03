{ pkgs, ... }:

{
  documentation.man = {
    generateCaches = true;
    man-db.enable = true;
  };

  environment.systemPackages = with pkgs; [ git vim ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };
}
