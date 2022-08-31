{ me, ... }: { ... }:

{
  home-manager.users.${me} = { pkgs, ... }: {
    home.packages = with pkgs; [ libsForQt5.plasma-browser-integration ];
  };
}
