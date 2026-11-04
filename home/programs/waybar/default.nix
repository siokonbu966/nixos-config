{ ... }:
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 6;

        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "battery"
          "tray"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };

        "sway/mode" = {
          format = "{}";
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip = false;
        };

        cpu = {
          format = "CPU {usage}%";
          interval = 5;
        };

        memory = {
          format = "MEM {percentage}%";
          interval = 5;
        };

        network = {
          interval = 5;
          format-wifi = "WiFi {signalStrength}%";
          format-ethernet = "ETH";
          format-disconnected = "offline";
        };

        backlight = {
          format = "BRT {percent}%";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "VOL muted";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "BAT {capacity}%";
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "Noto Sans", "Font Awesome";
        font-size: 14px;
      }

      window#waybar {
        background: rgba(30, 30, 30, 0.8);
        color: white;
      }

      #workspaces button {
        padding: 0 6px;
        color: #cccccc;
      }

      #workspaces button.focused {
        color: #ffffff;
      }

      #mode {
        padding: 0 6px;
        color: #2ca9e1;
      }

      #tray {
        padding: 0 6px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }
    '';
  };
}
