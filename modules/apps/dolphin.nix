{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.breeze-icons
    kdePackages.kio-extras
    kdePackages.kdegraphics-thumbnailers
    kdePackages.qtsvg
    kdePackages.kimageformats
  ];

  # System-wide KDE globals so Dolphin and Qt apps use breeze-dark icons & dark mode out of the box
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    ColorScheme=BreezeDark
    Name=Breeze Dark

    [Icons]
    Theme=breeze-dark

    [KDE]
    widgetStyle=Breeze

    [Colors:Window]
    BackgroundNormal=36,41,46
    ForegroundNormal=239,240,241

    [Colors:View]
    BackgroundNormal=30,34,39
    ForegroundNormal=239,240,241

    [Colors:Button]
    BackgroundNormal=49,54,59
    ForegroundNormal=239,240,241

    [Colors:Selection]
    BackgroundNormal=61,174,233
    ForegroundNormal=255,255,255

    [Colors:Tooltip]
    BackgroundNormal=49,54,59
    ForegroundNormal=239,240,241
  '';

  # Enable Qt module integration and dconf
  qt.enable = true;
  programs.dconf.enable = true;
}
