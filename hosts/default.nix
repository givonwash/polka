{
  mkHost = { forHostName, system }: { pkgs, ... }: {
    imports = [ (./. + "/${forHostName}") ];

    networking.hostName = forHostName;

    nix = with pkgs; {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      package = nixFlakes;
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "21.11";
  };
}
