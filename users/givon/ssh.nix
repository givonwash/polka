{ me, ... }:

{
  home-manager.users.${me} = {
    programs.ssh = {
      enable = true;
    };
  };
}
