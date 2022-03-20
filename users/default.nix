{
  mkUser = { config, system, user }: { ... }: {
    config._.${user} = config;

    imports = [
      (import (./. + "/${user}") { me = user; })
    ];
  };
}
