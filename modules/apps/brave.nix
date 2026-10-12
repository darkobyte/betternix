{ pkgs, ... }:
let
  braveClean = pkgs.writeShellScriptBin "brave" ''
    # Automatically clean stale Singleton lock left over from previous hostname/shutdown
    if [ -d "$HOME/.config/BraveSoftware/Brave-Browser" ]; then
      rm -f "$HOME/.config/BraveSoftware/Brave-Browser/Singleton"*
    fi
    exec ${pkgs.brave}/bin/brave "$@"
  '';
in
{
  environment.systemPackages = [
    pkgs.brave
    braveClean
  ];

  # Wrapper desktop entry ensure Brave is discoverable as brave and brave-browser
  environment.etc."xdg/applications/brave.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Name=Brave Web Browser
    Comment=Access the Internet
    Exec=${braveClean}/bin/brave %U
    StartupNotify=true
    Terminal=false
    Icon=brave
    Type=Application
    Categories=Network;WebBrowser;
    MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;
  '';
}
