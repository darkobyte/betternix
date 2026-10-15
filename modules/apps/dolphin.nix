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

  # System-wide KDE globals so Dolphin and Qt apps use breeze-dark icons out of the box
  environment.etc."xdg/kdeglobals".text = ''
    [Icons]
    Theme=breeze-dark
  '';

  # Enable Qt module integration and dconf
  qt.enable = true;
  programs.dconf.enable = true;
}
