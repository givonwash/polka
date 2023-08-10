{
  description = "NixOS System Configuration";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, nixpkgs, ... }:
    let
      inherit (builtins) listToAttrs;
      utils = (import ./utils) { inherit home-manager nixpkgs; };
      inherit (utils) mkConfig;
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
                overlays = [ (import ./overlays) ];
              };
              pkgs = import nixpkgs ({ inherit system; } // nixpkgsConfig);
            in
            mkConfig {
              inherit system;
              hostName = name;
              users = [
                {
                  name = givon;
                  config = {
                    extraPkgs = with pkgs; [
                      bitwarden-cli
                      docker-compose
                      obsidian
                      signal-desktop
                      slack
                      spotify
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
              extraModules = [
                { nixpkgs = nixpkgsConfig; }
                { home-manager.useUserPackages = true; }
              ];
            };
        }
      ];
    };
}
