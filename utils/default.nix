{ home-manager, nixpkgs }:

let
  userUtils = import ../users;
  hostUtils = import ../hosts;
  inherit (userUtils) mkUser;
  inherit (hostUtils) mkHost;
  lib = nixpkgs.lib;
in
lib.fix (self: {
  css = import ./css.nix { inherit lib self; };
  mkConfig = { hostName, users, system, extraModules }:
    let
      hostConfig = mkHost { inherit hostName; };
      userConfigs = map
        (user: mkUser {
          inherit system;
          inherit (user) config;
          user = user.name;
          utils = self;
        })
        users;
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
      ++ extraModules;
    };
})
