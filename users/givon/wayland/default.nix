{ me, utils, ... }: { ... }:

{
  imports = [
    (import ./sway { inherit me utils; })
    (import ./plasma.nix { inherit me utils; })
  ];

  home-manager.users.${me} = { pkgs, ... }: {
    home.packages = with pkgs; [ wl-clipboard ];
  };
}
