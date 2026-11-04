{ ... }:
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 4;

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
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(23, 35, 43, 0.96);
        border-bottom: 1px solid #344752;
        color: #dce7eb;
      }

      tooltip {
        background: #1d2c35;
        border: 1px solid #405661;
        border-radius: 6px;
      }

      tooltip label {
        color: #dce7eb;
      }

      #workspaces button {
        margin: 4px 1px;
        padding: 0 9px;
        border-radius: 5px;
        border: none;
        background: transparent;
        color: #a8bac2;
        box-shadow: none;
      }

      #workspaces button:hover {
        background: #293c46;
        box-shadow: none;
      }

      #workspaces button.focused {
        background: #365461;
        color: #edf4f6;
      }

      #workspaces button.urgent {
        background: #49343e;
        color: #f0dfe3;
      }

      #mode {
        margin: 4px 2px;
        padding: 0 9px;
        border-radius: 5px;
        background: #365461;
        color: #edf4f6;
      }

      #clock,
      #pulseaudio,
      #battery {
        margin: 4px 2px;
        padding: 0 9px;
        border-radius: 5px;
        background: #1d2c35;
        color: #dce7eb;
      }

      #clock {
        color: #c5d4da;
      }

      #pulseaudio.muted {
        color: #8499a3;
      }

      #battery.charging {
        color: #a9c8c0;
      }

      #battery.warning:not(.charging) {
        color: #e0c79b;
      }

      #battery.critical:not(.charging) {
        background: #49343e;
        color: #f0dfe3;
      }

      #tray {
        margin: 4px 2px;
        padding: 0 7px;
        border-radius: 5px;
        background: #1d2c35;
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
