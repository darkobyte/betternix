{ pkgs, ... }:
let
  # Wrapper binary ensuring stale zed socket/processes don't block opening files
  zedScript = pkgs.writeShellScriptBin "zed" ''
    exec ${pkgs.zed-editor}/bin/zeditor "$@"
  '';
in
{
  environment.systemPackages = [
    pkgs.zed-editor
    zedScript
  ];

  # Wrapper desktop entry ensure Zed is registered and easily launched by fuzzel/rofi/menus
  environment.etc."xdg/applications/zed.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Zed
    GenericName=Text Editor
    Comment=A high-performance, multiplayer code editor.
    Exec=${pkgs.zed-editor}/bin/zeditor %F
    Icon=zed
    Terminal=false
    Type=Application
    Categories=Development;TextEditor;IDE;
    MimeType=text/plain;inode/directory;
  '';
}
