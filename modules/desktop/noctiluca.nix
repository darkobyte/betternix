{ pkgs, ... }:
let
  # Noctiluca Bar / Shell Client daemon script
  noctilucaClient = pkgs.writeShellScriptBin "noctiluca" ''
    if command -v waybar >/dev/null 2>&1; then
      exec waybar -c /etc/noctiluca/config.jsonc -s /etc/noctiluca/style.css "$@"
    else
      echo "Noctiluca Shell Client starting..."
      exec sleep infinity
    fi
  '';
in
{
  environment.systemPackages = with pkgs; [
    waybar
    noctilucaClient
  ];

  # System-wide Noctiluca shell bar styling and JSON configuration
  environment.etc."noctiluca/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 32,
      "modules-left": ["custom/logo", "wlr/workspaces"],
      "modules-center": ["clock"],
      "modules-right": ["pulseaudio", "network", "battery", "tray"],
      "custom/logo": {
        "format": " 󱄅 PULSAR ",
        "tooltip": false
      },
      "clock": {
        "format": "{:%Y-%m-%d  %H:%M}"
      },
      "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-muted": "muted 󰖁"
      },
      "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} 󰈀",
        "format-disconnected": "Disconnected 󰖪"
      }
    }
  '';

  environment.etc."noctiluca/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 13px;
    }
    window#waybar {
      background-color: #0b0f19;
      color: #e2e8f0;
      border-bottom: 2px solid #38bdf8;
    }
  '';
}
