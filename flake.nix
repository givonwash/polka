{
  description = "NixOS System Configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { home-manager, nixpkgs, ... }:
    let
      inherit (builtins) listToAttrs;
      utils = (import ./utils) { inherit home-manager nixpkgs; };
    in
    {
      nixosConfigurations = listToAttrs [
        rec {
          name = "pamplemousse";
          value =
            let
              system = "x86_64-linux";
              nixpkgsConfig = { config.allowUnfree = true; };
              pkgs = import nixpkgs ({ inherit system; } // nixpkgsConfig);
            in
            utils.mkConfig {
              forHostName = name;
              forUsers = [
                {
                  name = "givon";
                  config = {
                    extraPkgs = with pkgs; [
                      signal-desktop
                      spotify
                    ];
                    git = {
                      email = "givonwash@gmail.com";
                      userName = "givonwash";
                    };
                    gnome.enable = true;
                    sway = {
                      enable = true;
                      keys = {
                        modifier = "Mod4";
                        left = "h";
                        down = "j";
                        up = "k";
                        right = "l";
                      };
                      launcher = pkgs.wofi;
                      locker = pkgs.swaylock;
                      terminal = pkgs.wezterm;
                      workspaces = [
                        { key = "1"; name = "1-web"; icon = ""; }
                        { key = "2"; name = "2-code"; icon = ""; }
                        { key = "3"; name = "3-extras"; icon = ""; }
                        { key = "0"; name = "4-music"; icon = ""; }
                      ];
                    };
                    theme = {
                      colors = {
                        blacks = [ "#161320" "#1A1826" "#1E1E2E" "#302D41" "#575268" ];
                        grays = [ "#6E6C7E" "#988BA2" "#C3BAC6" ];
                        blue = "#96CDFB";
                        flamingo = "#F2CDCD";
                        green = "#ABE9B3";
                        lavender = "#C9CBFF";
                        maroon = "#E8A2AF";
                        mauve = "#DDB6F2";
                        peach = "#F8BD96";
                        pink = "#F5C2E7";
                        red = "#F28FAD";
                        rosewater = "#F5E0DC";
                        sky = "#89DCEB";
                        teal = "#B5E8E0";
                        yellow = "#FAE3B0";
                        white = "#D9E0EE";
                      };
                      cursor = {
                        name = "Bibata-Original-Ice";
                        package = pkgs.bibata-cursors;
                      };
                      fonts = {
                        emoji = {
                          name = "Twitter Color Emoji";
                          package = pkgs.twitter-color-emoji;
                        };
                        icons = {
                          name = "Font Awesome 6 Free Solid";
                          package = pkgs.font-awesome;
                        };
                        monospace = {
                          name = "Iosevka Nerd Font";
                          package = pkgs.nerdfonts.override {
                            fonts = [ "Iosevka" ];
                          };
                        };
                        sans-serif = {
                          name = "Iosevka Etoile";
                          package = pkgs.iosevka-bin.override {
                            variant = "sgr-iosevka-etoile";
                          };
                        };
                        serif = {
                          name = "Noto Serif";
                          package = pkgs.noto-fonts;
                        };
                      };
                      gtkTheme = {
                        name = "Catppuccin";
                        package = pkgs.catppuccin-gtk;
                      };
                      icons = {
                        name = "Papirus-Dark";
                        package = pkgs.papirus-icon-theme;
                      };
                      wallpaper = {
                        mode = "stretch";
                        source = ./users/givon/wallpapers/waves.jpg;
                      };
                    };
                    userConfig = {
                      extraGroups = [ "networkmanager" "video" "wheel" ];
                      isNormalUser = true;
                    };
                  };
                }
              ];
              forSystem = system;
              withExtraModules = [
                { nixpkgs = nixpkgsConfig; }
                { home-manager.useUserPackages = true; }
              ];
            };
        }
      ];
    };
}
