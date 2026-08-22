{
  self,
  lib,
  home-manager,
  mediator,
  omp,
  lanzaboote,
  x86_64-linux,
  utilityModules,
  ...
}:
lib.nixosSystem {
  lib = lib;
  system = x86_64-linux;
  modules = [
    utilityModules.nixpkgs
    utilityModules.nix
    home-manager.nixosModules.default
    lanzaboote.nixosModules.lanzaboote
    self.nixosModules.pamplemousse
    self.nixosModules.givon
    self.homeModules.givon
    (
      { pkgs, ... }:
      {
        config._ = {
          pamplemousse = {
            gnome.enable = true;
            sway.enable = true;
          };
          givon = {
            extraPkgs = with pkgs; [
              (callPackage ../pkgs/ntn.nix { })
              gh
              mediator.packages.${system}.default
              omp.packages.${system}.default
              spotify
            ];
            firefox.enable = true;
            foliate.enable = true;
            git.enable = true;
            ghostty.enable = true;
            gpg.enable = true;
            shell.enable = true;
            wayland = {
              enable = true;
              gnome.enable = true;
              sway = {
                enable = true;
                mako.enable = true;
                swaylock.enable = true;
                waybar.enable = true;
                wofi.enable = true;
              };
            };
            xdg.enable = true;
            theme = {
              colors = import ../modules/home/givon/colors/catppuccin.nix;
              cursor.enable = true;
              gtkTheme.enable = true;
              icons.enable = true;
            };
            stateVersion = "22.05";
            userConfig = {
              name = "givon";
              home = "/home/givon";
              extraGroups = [
                "networkmanager"
                "video"
                "wheel"
              ];
              isNormalUser = true;
            };
          };
        };
      }
    )
  ];
}
