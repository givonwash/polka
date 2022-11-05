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
                rec {
                  name = "givon";
                  config = {
                    extraPkgs = with pkgs; [
                      obsidian
                      signal-desktop
                      spotify
                      zoom-us
                    ];
                    git.enable = true;
                    gnome.enable = true;
                    sway.enable = true;
                    theme.colors = import (./. + "/users/${name}/colors/catppuccin.nix");
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
