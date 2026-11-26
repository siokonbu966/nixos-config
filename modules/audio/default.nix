{ pkgs, ... }:

{
  systemd.services.alc897-noise-fix = {
    description = "Disable unused ALC897 microphone input gain";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" ];

    serviceConfig.Type = "oneshot";

    script = ''
      set -eu

      AMIXER="${pkgs.alsa-utils}/bin/amixer"

      # Disable unused microphone amplification
      $AMIXER -c Generic_1 sset 'Rear Mic Boost' 0
      $AMIXER -c Generic_1 sset 'Front Mic Boost' 0
      $AMIXER -c Generic_1 sset 'Line Boost' 0

      # Disable unused recording input
      $AMIXER -c Generic_1 sset 'Capture' 0
      $AMIXER -c Generic_1 sset 'Rear Mic' mute
    '';
  };
}
