{ pkgs, ... }:
let
  # Obsidian with Wayland ozone platform flags for crisp rendering on HiDPI display
  obsidianWayland = pkgs.writeShellScriptBin "obsidian" ''
    exec ${pkgs.obsidian}/bin/obsidian --ozone-platform-hint=auto "$@"
  '';
in
{
  environment.systemPackages = [
    pkgs.obsidian
    obsidianWayland
  ];

  # Desktop launcher entry for Obsidian
  environment.etc."xdg/applications/obsidian.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Obsidian
    Comment=Knowledge base and note-taking application
    Exec=${obsidianWayland}/bin/obsidian %u
    Icon=obsidian
    Terminal=false
    Type=Application
    Categories=Office;Utility;
    MimeType=x-scheme-handler/obsidian;
  '';
}
