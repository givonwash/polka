{ home-manager, pkgs, lib ? pkgs.lib, ... }@args:

let
  inherit (import ../users) mkUser;
  inherit (import ../hosts) mkHost;
in
lib.fix (polkaUtils:
  {
    color = import ./colors.nix {
      inherit pkgs lib polkaUtils;
    };
    css = import ./css.nix {
      inherit pkgs lib polkaUtils;
    };
    int = import ./int.nix {
      inherit pkgs lib polkaUtils;
    };
    mkConfig = { hostName, users, system ? args.system }:
      let
        inherit (builtins) elemAt length listToAttrs;
        inherit (lib) optionalAttrs;
        hostConfig = mkHost { inherit hostName; };
        userConfigs = map (user: mkUser { inherit user; }) users;
        userNames = map (user: user.name) users;
        homeManagerNixOsConfig = {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;

            extraSpecialArgs =
              let
                users = listToAttrs (map (user: { name = user; value = user; }) userNames);
              in
              { inherit polkaUtils users; }
              // (
                optionalAttrs (length userNames == 1) { me = elemAt userNames 0; }
              );
          };
        };
        nixpkgsConfig = { nixpkgs.pkgs = pkgs; };
      in
      {
        ${hostName} = lib.nixosSystem {
          inherit system;

          modules = [
            hostConfig
            home-manager.nixosModule
            homeManagerNixOsConfig
            nixpkgsConfig
          ]
          ++ userConfigs;

          specialArgs = homeManagerNixOsConfig.home-manager.extraSpecialArgs;
        };
      };
  })
