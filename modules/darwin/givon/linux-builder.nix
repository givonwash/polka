{
  nix = {
    linux-builder = {
      enable = true;
      maxJobs = 6;
      config = {
        virtualisation.cores = 3;
      };
    };
    settings = {
      trusted-users = [ "@admin" "givon" ];
      extra-trusted-users = [ "@admin" "givon" ];
    };
  };
}
