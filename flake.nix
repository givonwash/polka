{
  description = "NixOS System Configurations";

  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, flake-utils, home-manager, nixpkgs }:
    let
      inherit (flake-utils.lib.system) x86_64-linux;
      inherit (nixpkgs) lib;
    in
    {
      nixosModules = {
        # hosts
        frambuesa = ./modules/hosts/frambuesa;
        pamplemousse = ./modules/hosts/pamplemousse;

        # users
        givon = import ./modules/users/givon;

        # utilities
        nixpkgs = import ./modules/utils/nixpkgs.nix;
        nix = import ./modules/utils/nix.nix;
      };
      nixosConfigurations =
        let
          inherit (builtins) readDir;
          lib' = lib.extend (final: prev: {
            polka = prev.mapAttrs'
              (name: _: prev.nameValuePair (prev.removeSuffix ".nix" name) (import ./lib/${name} final))
              (prev.filterAttrs
                (entry: type: type == "regular" && (prev.hasSuffix ".nix" entry))
                (readDir ./lib));
          });
        in
        {
          frambuesa = lib'.nixosSystem {
            lib = lib';
            system = x86_64-linux;
            modules = [
              self.nixosModules.nixpkgs
              self.nixosModules.nix
              home-manager.nixosModule
              self.nixosModules.frambuesa
              self.nixosModules.givon
              {
                config._.givon = {
                  git.enable = true;
                  gnome.enable = true;
                  neovim.enable = true;
                  sway.enable = true;
                  theme.colors = import ./modules/users/givon/colors/catppuccin.nix;
                  userConfig = {
                    extraGroups = [ "networkmanager" "video" "wheel" ];
                    isNormalUser = true;
                  };
                };
              }
            ];
          };
          pamplemousse = lib'.nixosSystem {
            lib = lib';
            system = x86_64-linux;
            modules = [
              self.nixosModules.nixpkgs
              self.nixosModules.nix
              home-manager.nixosModule
              self.nixosModules.pamplemousse
              self.nixosModules.givon
              ({ pkgs, ... }: {
                config._.givon = {
                  extraPkgs = with pkgs; [
                    element-desktop
                    inkscape
                    obsidian
                    signal-desktop
                    slack
                    spotify
                    zulip
                  ];
                  git.enable = true;
                  gnome.enable = true;
                  neovim = { enable = true; obsidian-nvim.enable = true; };
                  sway.enable = true;
                  theme.colors = import ./modules/users/givon/colors/catppuccin.nix;
                  userConfig = {
                    extraGroups = [ "networkmanager" "video" "wheel" ];
                    isNormalUser = true;
                  };
                };
              })
            ];
          };
        };
    };
}
