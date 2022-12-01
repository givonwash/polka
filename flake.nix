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
              givon = "givon";
              system = "x86_64-linux";
              nixpkgsConfig = {
                config.allowUnfree = true;
                overlays = [ (import ./overlays { inherit pkgs; }) ];
              };
              pkgs = import nixpkgs ({ inherit system; } // nixpkgsConfig);
            in
            utils.mkConfig {
              forHostName = name;
              forUsers = [
                {
                  name = givon;
                  config = {
                    extraPkgs = with pkgs; [
                      obsidian
                      signal-desktop
                      slack
                      spotify
                      zoom-us
                    ];
                    git.enable = true;
                    gnome.enable = true;
                    neovim = { enable = true; obsidian-nvim.enable = true; };
                    sway.enable = true;
                    theme.colors = import (./. + "/users/${givon}/colors/catppuccin.nix");
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
