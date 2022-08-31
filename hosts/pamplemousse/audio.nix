{ pkgs, ... }:

{
  services.pipewire = {
    alsa = {
      enable = true;
      support32Bit = true;
    };
    enable = true;
    pulse.enable = true;
  };
  systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];
}
