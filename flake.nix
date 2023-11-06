{
  description = "NixOS System Configuration";

  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, flake-utils, home-manager, nixpkgs }:
    let
      inherit (flake-utils.lib.system) x86_64-linux;
    in
    {
      nixosConfigurations =
        let
          system = x86_64-linux;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ (import ./overlays) ];
          };
          lib' = import ./lib {
            inherit system home-manager pkgs;
            inherit (nixpkgs) lib;
          };
          inherit (lib') mkConfig;
        in
        mkConfig {
          hostName = "pamplemousse";
          users = let name = "givon"; in
            [
              {
                inherit name;
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
                  theme.colors = import (./. + "/users/${name}/colors/catppuccin.nix");
                  userConfig = {
                    extraGroups = [ "networkmanager" "video" "wheel" ];
                    isNormalUser = true;
                  };
                };
              }
            ];
        };
    };
}
