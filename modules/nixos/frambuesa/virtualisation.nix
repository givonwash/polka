{

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    vmware.guest.enable = true;
  };
}
