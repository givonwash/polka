{ me, utils, ... }: { ... }:

{
  imports = [
    (import ./sway { inherit me utils; })
  ];
}
