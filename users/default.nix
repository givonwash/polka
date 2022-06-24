{
  mkUser = { config, system, user, utils }: { ... }: {
    config._.${user} = config;

    imports = [
      (import (./. + "/${user}") { me = user; utils = utils; })
    ];
  };
}
