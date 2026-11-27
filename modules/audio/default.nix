{ pkgs, ... }:

{
  # Start the fix when the Generic_1 card itself registers, instead of
  # waiting for whichever card happens to activate sound.target first.
  # The script also polls for the card, so this rule only decides when the
  # first start attempt happens (and re-triggers it if it ran too early).
  services.udev.extraRules = ''
    SUBSYSTEM=="sound", KERNEL=="controlC*", ATTRS{id}=="Generic_1", TAG+="systemd", ENV{SYSTEMD_WANTS}="alc897-noise-fix.service"
  '';

  systemd.services.alc897-noise-fix = {
    description = "Disable unused ALC897 microphone input gain";
    wantedBy = [ "multi-user.target" ];
    after = [ "sound.target" ];

    serviceConfig = {
      Type = "oneshot";
      # Retry if the card did not show up within the wait window; the next
      # attempt runs after RestartSec (or when udev sees the card appear).
      Restart = "on-failure";
      RestartSec = "10";
    };

    script = ''
      set -eu

      AMIXER="${pkgs.alsa-utils}/bin/amixer"
      CARD=Generic_1

      # sound.target only guarantees that *some* card became available, and
      # part of the snd_hda_intel codec probe runs as deferred work, so this
      # card (or its controls) may not exist yet even after modprobe returns.
      # Wait until every control we touch is present so set -eu can never
      # abort halfway and leave the fix partially applied.
      ready() {
        $AMIXER -c "$CARD" sget 'Rear Mic Boost' >/dev/null 2>&1 &&
        $AMIXER -c "$CARD" sget 'Front Mic Boost' >/dev/null 2>&1 &&
        $AMIXER -c "$CARD" sget 'Line Boost' >/dev/null 2>&1 &&
        $AMIXER -c "$CARD" sget 'Capture' >/dev/null 2>&1 &&
        $AMIXER -c "$CARD" sget 'Rear Mic' >/dev/null 2>&1
      }

      tries=0
      until ready; do
        if [ "$tries" -ge 60 ]; then
          echo "$CARD did not become ready within 60s" >&2
          exit 1
        fi
        tries=$((tries + 1))
        sleep 1
      done

      # Disable unused microphone amplification
      $AMIXER -c "$CARD" sset 'Rear Mic Boost' 0
      $AMIXER -c "$CARD" sset 'Front Mic Boost' 0
      $AMIXER -c "$CARD" sset 'Line Boost' 0

      # Disable unused recording input
      $AMIXER -c "$CARD" sset 'Capture' 0
      $AMIXER -c "$CARD" sset 'Rear Mic' mute
    '';
  };
}
