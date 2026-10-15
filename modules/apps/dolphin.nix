{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.breeze-icons
    kdePackages.kio-extras
    kdePackages.kdegraphics-thumbnailers
  ];

  # Enable dconf for GTK/KDE file picker and desktop settings integration
  programs.dconf.enable = true;
}
