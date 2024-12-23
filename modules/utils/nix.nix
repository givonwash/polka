{ pkgs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    settings.experimental-features = [ "nix-command" "flakes" ];
    package = pkgs.nixVersions.stable;
  };
}
