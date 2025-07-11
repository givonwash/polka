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
      inherit (flake-utils.lib.system) aarch64-darwin x86_64-darwin x86_64-linux;
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
        guanabana = ./modules/darwin/guanabana;
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
      darwinConfigurations = {
        Givon-Washington-Guanabana =
          let
            system = aarch64-darwin;
          in
          nix-darwin.lib.darwinSystem {
            inherit system;
            lib = lib';
            modules = [
              home-manager.darwinModules.default
              self.utilityModules.nix
              self.utilityModules.nixpkgs
              self.darwinModules.guanabana
              self.darwinModules.givon
              self.homeModules.givon
              {
                _.guanabana.homebrew.enable = true;
                _.givon = {
                  git.enable = true;
                  homebrew.enable = true;
                  theme = {
                    colors = import ./modules/home/givon/colors/catppuccin.nix;
                    fonts = {
                      defaultSize = 15;
                      emoji = {
                        name = "Apple Color Emoji";
                        package = null;
                      };
                    };
                  };
                  neovim.enable = true;
                  shell.enable = true;
                  wezterm = {
                    enable = true;
                    enableInstallation = false;
                    enableHomebrewInstallation = true;
                    appearance.fontSize = 17.5;
                  };
                  stateVersion = "23.11";
                  userConfig = {
                    name = "givon";
                    home = "/Users/givon";
                  };
                };
              }
            ];
          };
        Givon-Washington-Pera = nix-darwin.lib.darwinSystem {
          lib = lib';
          system = x86_64-darwin;
          modules = [
            home-manager.darwinModules.default
            self.utilityModules.nix
            self.utilityModules.nixpkgs
            self.darwinModules.pera
            self.darwinModules.givon
            self.homeModules.givon
            {
              _.pera.homebrew.enable = true;
              _.givon = {
                git.enable = true;
                homebrew.enable = true;
                theme = {
                  colors = import ./modules/home/givon/colors/catppuccin.nix;
                  fonts = {
                    defaultSize = 15;
                    emoji = {
                      name = "Apple Color Emoji";
                      package = null;
                    };
                  };
                };
                neovim.enable = true;
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
        };
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
                    firefox.enable = true;
                    git.enable = true;
                    gpg.enable = true;
                    neovim.enable = true;
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
                      colors = import ./modules/home/givon/colors/catppuccin.nix;
                      cursor.enable = true;
                      gtkTheme.enable = true;
                      icons.enable = true;
                    };
                    stateVersion = "22.05";
                    userConfig = {
                      name = "givon";
                      home = "/home/givon";
                      extraGroups = [ "networkmanager" "video" "wheel" ];
                      isNormalUser = true;
                    };
                  };
                };
              }
            ];
          };
          pamplemousse = lib'.nixosSystem
            {
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
                  config._ = {
                    pamplemousse = {
                      gnome.enable = true;
                      sway.enable = true;
                    };
                    givon = {
                      extraPkgs = with pkgs; [
                        element-desktop
                        inkscape
                        obsidian
                        signal-desktop
                        slack
                        spotify
                        zulip
                      ];
                      firefox.enable = true;
                      foliate.enable = true;
                      git.enable = true;
                      gnome.enable = true;
                      gpg.enable = true;
                      neovim = { enable = true; };
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
                        colors = import ./modules/home/givon/colors/catppuccin.nix;
                        cursor.enable = true;
                        gtkTheme.enable = true;
                        icons.enable = true;
                      };
                      stateVersion = "22.05";
                      userConfig = {
                        name = "givon";
                        home = "/home/givon";
                        extraGroups = [ "networkmanager" "video" "wheel" ];
                        isNormalUser = true;
                      };
                    };
                  };
                })
              ];
            };
        };
    };
}
