{ pkgs, ... }:
let
  wallpaper = ../../assets/wallpapers/default.png;
in
{
  environment.systemPackages = with pkgs; [
    swww
    adwaita-icon-theme
  ];

  # Setup default wallpaper path in /etc/pulsar/wallpaper.png
  environment.etc."pulsar/wallpaper.png".source = wallpaper;

  # GTK / styling hints
  environment.variables = {
    PULSAR_WALLPAPER = "/etc/pulsar/wallpaper.png";
    GTK_THEME = "Adwaita:dark";
  };
}
