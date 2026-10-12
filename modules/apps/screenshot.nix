{ pkgs, ... }:
let
  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    set -euo pipefail

    DIR="''${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"
    mkdir -p "$DIR"
    TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
    FILE="$DIR/Screenshot_$TIMESTAMP.png"

    notify() {
      if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Screenshot Tool" "$1" "$2"
      fi
    }

    mode="''${1:-edit}"

    case "$mode" in
      fullscreen|full)
        ${pkgs.grim}/bin/grim "$FILE"
        ${pkgs.wl-clipboard}/bin/wl-copy < "$FILE"
        notify "Screenshot Captured" "Full screen saved to $FILE and copied to clipboard"
        ;;
      area|region)
        GEOM=$(${pkgs.slurp}/bin/slurp 2>/dev/null) || exit 0
        ${pkgs.grim}/bin/grim -g "$GEOM" "$FILE"
        ${pkgs.wl-clipboard}/bin/wl-copy < "$FILE"
        notify "Screenshot Captured" "Area saved to $FILE and copied to clipboard"
        ;;
      edit|annotate)
        GEOM=$(${pkgs.slurp}/bin/slurp 2>/dev/null) || exit 0
        ${pkgs.grim}/bin/grim -g "$GEOM" - | ${pkgs.swappy}/bin/swappy -f - -o "$FILE"
        ;;
      *)
        echo "Usage: screenshot [edit|area|full]"
        exit 1
        ;;
    esac
  '';
in
{
  environment.systemPackages = with pkgs; [
    grim
    slurp
    swappy
    grimblast
    libnotify
    screenshotScript
  ];

  # Desktop launcher entry for screenshot tool in app menus
  environment.etc."xdg/applications/screenshot.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Screenshot Tool
    GenericName=Screenshot Tool
    Comment=Capture and annotate screen regions
    Exec=${screenshotScript}/bin/screenshot edit
    Icon=accessories-screenshot
    Terminal=false
    Type=Application
    Categories=Utility;Graphics;
    Keywords=screenshot;screenshottool;snip;capture;
  '';
}
