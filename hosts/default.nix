{
  mkHost = { hostName }: { pkgs, ... }: {
    imports = [ (./. + "/${hostName}") ];

    networking.hostName = hostName;

    nix = with pkgs; {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      package = nixVersions.stable;
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "21.11";
  };
}
