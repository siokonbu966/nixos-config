# Tool services managed from ~/src/tool — grouped by genre:
#   web/       self-hosted web apps (gitea, linkding, penpot, pydio, vikunja)
#   media/     media servers (jellyfin)
#   files/     file transfer and sharing (samba)
#   research/  knowledge bases and search (altero, rustxng)
#   dev/       bots and helper tools (color-dis-bot)
#
# Each service is listed individually here, so enabling/disabling one is
# a single-line change. These are Home Manager / darwin modules
# (launchd.agents); they are only imported by hosts that actually run
# the services (currently darwin zephyr, via home/zephyr.nix).
{ ... }:
{
  imports = [
    # shared helpers
    ./lib/port-watchdog

    # web
    ./web/gitea
    ./web/linkding
    ./web/penpot
    ./web/pydio
    ./web/vikunja

    # media
    ./media/jellyfin

    # files
    ./files/samba

    # research
    ./research/altero
    ./research/rustxng

    # dev
    ./dev/color-dis-bot
  ];
}
