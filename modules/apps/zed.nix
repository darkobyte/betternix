{ pkgs, ... }:
let
  # Wrapper binary so running either `zed` or `zeditor` launches the editor cleanly with Wayland flags
  zedWrapped = pkgs.writeShellScriptBin "zed" ''
    exec zeditor "$@"
  '';
in
{
  environment.systemPackages = with pkgs; [
    zed-editor
    zedWrapped
  ];

  # Wrapper desktop entry ensure Zed is registered and easily launched by fuzzel/rofi/menus
  environment.etc."xdg/applications/zed.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Zed
    GenericName=Text Editor
    Comment=A high-performance, multiplayer code editor.
    Exec=zeditor %F
    Icon=zed
    Terminal=false
    Type=Application
    Categories=Development;TextEditor;IDE;
    MimeType=text/plain;inode/directory;
  '';
}
