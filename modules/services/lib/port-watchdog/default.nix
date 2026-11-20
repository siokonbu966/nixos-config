# Periodic health check for docker compose services' published ports.
#
# colima/lima forwards container ports to the host over ssh. When that
# forward fails at container start (host port already bound by another
# process, stale ssh mux master after a colima restart, ...) the hostagent
# logs a warning and NEVER retries, so the service silently becomes
# unreachable from outside until the container happens to be recreated.
#
# This agent checks every published host port of every running compose
# container; if one is not reachable, it restarts the container, which
# triggers lima to re-add the forward. A per-container failure counter
# (reset on success) caps restarts at 3 in a row so a genuinely
# unbindable port cannot cause a restart loop.
{ config, pkgs, lib, ... }:
let
  checkScript = pkgs.writeShellScript "compose-port-watchdog-check" ''
    export DOCKER_HOST="''${DOCKER_HOST:-unix://$HOME/.colima/default/docker.sock}"

    # colima may still be starting (e.g. right after login); give up
    # quietly instead of piling up errors.
    elapsed=0
    until ${pkgs.docker-client}/bin/docker info >/dev/null 2>&1; do
      if [ "$elapsed" -ge 120 ]; then
        exit 0
      fi
      sleep 5
      elapsed=$((elapsed + 5))
    done

    state_dir="$HOME/.cache/compose-port-watchdog"
    mkdir -p "$state_dir"

    ${pkgs.docker-client}/bin/docker ps \
      --filter label=com.docker.compose.project \
      --format '{{.Names}}' |
    while IFS= read -r container; do
      published="$(${pkgs.docker-client}/bin/docker port "$container" 2>/dev/null || true)"
      [ -n "$published" ] || continue

      missing=0
      while IFS= read -r mapping; do
        case "$mapping" in
          *"->"*) ;;
          *) continue ;;
        esac
        spec="''${mapping#*->}"
        # " 0.0.0.0:445": awk drops the leading whitespace
        spec=$(printf '%s\n' "$spec" | awk '{print $1}')
        case "$spec" in *-*) continue ;; esac  # port ranges: skip
        host_ip="''${spec%:*}"
        # ssh/lima only maintains IPv4 forwards on the host; the [::]
        # entries docker reports have no host listener and are not
        # expected to be reachable.
        case "$host_ip" in '[::]') continue ;; esac
        host_port="''${spec##*:}"
        if ! /usr/bin/nc -z -G 2 "$host_ip" "$host_port" >/dev/null 2>&1; then
          echo "$container: host port $host_ip:$host_port unreachable"
          missing=1
        fi
      done <<EOF
$published
EOF

      counter="$state_dir/$container"
      if [ "$missing" -eq 0 ]; then
        rm -f "$counter"
        continue
      fi

      fails="$(cat "$counter" 2>/dev/null || true)"
      fails="''${fails:-0}"
      case "$fails" in '''|*[!0-9]*) fails=0 ;; esac
      if [ "$fails" -ge 3 ]; then
        echo "$container: unreachable but restart cap (3) reached, skipping" >&2
        continue
      fi
      echo "$((fails + 1))" > "$counter"
      echo "$container: restarting to re-establish colima port forward (attempt $((fails + 1))/3)"
      ${pkgs.docker-client}/bin/docker restart "$container" >/dev/null
    done
  '';
in
{
  launchd.agents."compose-port-watchdog" = {
    enable = true;
    config = {
      Program = "${checkScript}";
      RunAtLoad = true;
      StartInterval = 300;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/compose-port-watchdog.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/compose-port-watchdog.err.log";
    };
  };
}
