{
  self,
  lib,
  home-manager,
  nix-darwin,
  x86_64-darwin,
  utilityModules,
  ...
}:
nix-darwin.lib.darwinSystem {
  lib = lib;
  system = x86_64-darwin;
  modules = [
    home-manager.darwinModules.default
    utilityModules.nix
    utilityModules.nixpkgs
    self.darwinModules.pera
    self.darwinModules.givon
    self.homeModules.givon
    {
      _.pera.homebrew.enable = true;
      _.givon = {
        git.enable = true;
        homebrew.enable = true;
        theme = {
          colors = import ../modules/home/givon/colors/catppuccin.nix;
          fonts = {
            defaultSize = 15;
            emoji = {
              name = "Apple Color Emoji";
              package = null;
            };
          };
        };
        shell.enable = true;
        wezterm = {
          enable = true;
          enableInstallation = false;
          enableHomebrewInstallation = true;
          appearance.fontSize = 17.5;
        };
        stateVersion = "23.11";
        userConfig = {
          name = "givonwashington";
          home = "/Users/givonwashington";
        };
      };
    }
  ];
}
