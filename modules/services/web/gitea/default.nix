# Gitea — self-hosted git server (web via Cloudflare Tunnel, SSH on 2222).
# Data lives in ~/src/tool/gitea/gitea.
{ config, ... }:
{
  imports = [
    (import ../../lib/compose.nix {
      name = "gitea";
      compose = {
        networks.gitea = { };

        services.server = {
          image = "docker.gitea.com/gitea:28.4";
          container_name = "gitea";
          restart = "always";
          networks = [ "gitea" ];
          environment = {
            USER_UID = "1000";
            USER_GID = "1000";
            GITEA__server__ROOT_URL = "https://gitea.ns-siokon.f5.si/";
            GITEA__server__SSH_DOMAIN = "gitea_ssh.ns-siokon.f5.si";
            GITEA__server__SSH_PORT = "2222";
            GITEA__session__PROVIDER = "db";
          };
          volumes = [
            "${config.home.homeDirectory}/src/tool/gitea/gitea:/data"
            "/etc/timezone:/etc/timezone:ro"
            "/etc/localtime:/etc/localtime:ro"
          ];
          ports = [
            "50001:3000"
            "2222:22"
          ];
        };
      };
    })
  ];
}
