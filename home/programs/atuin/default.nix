{ ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    flags = [ "--disable-up-arrow" ];

    settings = {
      # Self-hosted sync server on zephyr, exposed via tailscale serve.
      sync_address = "https://zephyr.tail32a8e5.ts.net:10002";
    };
  };
}
