{
  description = "NixOS System Configurations";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, home-manager, nixpkgs, nix-darwin }:
    let
      inherit (flake-utils.lib.system) x86_64-darwin x86_64-linux;
      inherit (nixpkgs) lib;
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
      darwinModules = {
        pera = ./modules/darwin/pera;
        givon = ./modules/darwin/givon;
      };
      homeModules = {
        givon = ./modules/home/givon;
      };
      nixosModules = {
        frambuesa = ./modules/nixos/frambuesa;
        pamplemousse = ./modules/nixos/pamplemousse;
        givon = ./modules/nixos/givon;
      };
      utilityModules = {
        nix = ./modules/utils/nix.nix;
        nixpkgs = ./modules/utils/nixpkgs.nix;
      };
      darwinConfigurations.Givon-Washington-Pera = nix-darwin.lib.darwinSystem {
        lib = lib';
        system = x86_64-darwin;
        modules = [
          home-manager.darwinModule
          self.utilityModules.nix
          self.utilityModules.nixpkgs
          self.darwinModules.pera
          self.darwinModules.givon
          self.homeModules.givon
          {
            _.givon = {
              git.enable = true;
              theme = {
                colors = import ./modules/home/givon/colors/catppuccin.nix;
                fonts.emoji = {
                  name = "Apple Color Emoji";
                  package = null;
                };
              };
              neovim.enable = true;
              shell.enable = true;
              wezterm = {
                enable = true;
                enableInstallation = false;
              };
              stateVersion = "23.11";
              userConfig = {
                name = "givonwashington";
                home = "/Users/givonwashington";
              };
            };
          }
        ];
      };
      nixosConfigurations =
        {
          frambuesa = lib'.nixosSystem {
            lib = lib';
            system = x86_64-linux;
            modules = [
              self.utilityModules.nixpkgs
              self.utilityModules.nix
              home-manager.nixosModule
              self.nixosModules.frambuesa
              self.nixosModules.givon
              self.homeModules.givon
              {
                config._ = {
                  frambuesa.gnome.enable = true;
                  givon = {
                    git.enable = true;
                    gnome.enable = true;
                    neovim.enable = true;
                    theme.colors = import ./modules/home/givon/colors/catppuccin.nix;
                    stateVersion = "22.05";
                    userConfig = {
                      extraGroups = [ "networkmanager" "video" "wheel" ];
                      isNormalUser = true;
                    };
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
              self.homeModules.givon
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
                  stateVersion = "22.05";
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
