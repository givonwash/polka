{
  description = "NixOS System Configurations";

  inputs = {
    # Utilities
    flake-utils.url = "github:numtide/flake-utils";

    # System managers
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";

    # Nixpkgs versions
    nixpkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";

    # Separate input for frequently-updated CLI tools
    # Update independently with: nix flake lock --update-input cliPkgs
    cliPkgs.url = "github:NixOs/nixpkgs/nixpkgs-unstable";

    # Personal flakes
    mediator.url = "github:givonwash/mediator";

    omp.url = "github:can1357/oh-my-pi";
  };

  outputs =
    { self
    , flake-utils
    , home-manager
    , mediator
    , nixpkgs
    , cliPkgs
    , nix-darwin
    , mac-app-util
    , omp
    }:
    let
      inherit (flake-utils.lib.system) aarch64-darwin x86_64-darwin x86_64-linux;
      inherit (nixpkgs) lib;
      inherit (builtins) readDir;

      lib' = lib.extend (
        final: prev:
          let
            inherit (prev)
              filterAttrs
              hasSuffix
              mapAttrs'
              nameValuePair
              removeSuffix
              ;
            myLibEntries = readDir ./lib;
            nixFiles = filterAttrs (entry: type: type == "regular" && (hasSuffix ".nix" entry)) myLibEntries;
          in
          {
            polka = mapAttrs'
              (
                name: _: nameValuePair (removeSuffix ".nix" name) (import ./lib/${name} final)
              )
              nixFiles;
          }
      );

      machineArgs = {
        inherit self home-manager mediator nixpkgs cliPkgs nix-darwin mac-app-util omp;
        inherit aarch64-darwin x86_64-darwin x86_64-linux;
        lib = lib';
      };
      darwinConfigurations = {
        Givon-Washington-Guanabana = import ./machines/guanabana.nix machineArgs;
        Givon-Washington-Pera = import ./machines/pera.nix machineArgs;
      };

      nixosConfigurations = {
        frambuesa = import ./machines/frambuesa.nix machineArgs;
        pamplemousse = import ./machines/pamplemousse.nix machineArgs;
      };

      # Toplevel derivations keyed by short machine name.
      machineToplevels = {
        guanabana = darwinConfigurations.Givon-Washington-Guanabana.system;
        pera = darwinConfigurations.Givon-Washington-Pera.system;
        frambuesa = nixosConfigurations.frambuesa.config.system.build.toplevel;
        pamplemousse = nixosConfigurations.pamplemousse.config.system.build.toplevel;
      };

      # Machines buildable on each system (darwin configs only build on macOS).
      machinesBySystem = {
        aarch64-darwin = [ "guanabana" ];
        x86_64-darwin = [ "pera" ];
        x86_64-linux = [ "frambuesa" "pamplemousse" ];
      };

      # Per-system checks and aggregate of every machine buildable on that system.
      perSystem = flake-utils.lib.eachSystem (builtins.attrNames machinesBySystem) (
        system:
        let
          machines = machinesBySystem.${system};
        in
        {
          checks = lib.genAttrs machines (name: machineToplevels.${name});
        }
      );

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
      inherit darwinConfigurations nixosConfigurations;

      checks = perSystem.checks;
    };
}
