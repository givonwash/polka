{
  mkUser = { user }: {
    config._.${user.name} = user.config;

    imports = [ (./. + "/${user.name}") ];
  };
}
