{
  self,
  lib,
  home-manager,
  mediator,
  omp,
  x86_64-linux,
  ...
}:
lib.nixosSystem {
  lib = lib;
  system = x86_64-linux;
  modules = [
    self.utilityModules.nixpkgs
    self.utilityModules.nix
    home-manager.nixosModules.default
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
              gemini-cli
              gh
              mediator.packages.${system}.default
              omp.packages.${system}.default
              spotify
            ];
            firefox.enable = true;
            foliate.enable = true;
            git.enable = true;
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
            wezterm = {
              enable = true;
              appearance.windowDecorations = "INTEGRATED_BUTTONS | RESIZE";
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
