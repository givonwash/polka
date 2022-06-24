{ home-manager, nixpkgs }:

let
  users = import ../users;
  hosts = import ../hosts;
  lib = nixpkgs.lib;
in
lib.fix (self: {
  css = import ./css.nix { inherit lib self; };
  mkConfig = { forHostName, forUsers, forSystem, withExtraModules }:
    let
      system = forSystem;
      hostConfig = hosts.mkHost { inherit forHostName system; };
      userConfigs = map
        (user: users.mkUser {
          inherit system;
          inherit (user) config;
          user = user.name;
          utils = self;
        })
        forUsers;
      homeManagerNixOsConfig = { home-manager.useGlobalPkgs = true; };
    in
    lib.nixosSystem {
      inherit system;

      modules = [
        hostConfig
        home-manager.nixosModule
        homeManagerNixOsConfig
      ]
      ++ userConfigs
      ++ withExtraModules;
    };
})
