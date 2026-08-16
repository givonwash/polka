{
  self,
  lib,
  home-manager,
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
    self.nixosModules.frambuesa
    self.nixosModules.givon
    self.homeModules.givon
    {
      config._ = {
        frambuesa.gnome.enable = true;
        givon = {
          firefox.enable = true;
          git.enable = true;
          gpg.enable = true;
          shell.enable = true;
          wayland = {
            enable = true;
            gnome.enable = true;
          };
          wezterm = {
            enable = true;
            enableWayland = "false";
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
  ];
}
