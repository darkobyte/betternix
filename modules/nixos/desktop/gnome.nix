{ pkgs, ... }:

{
  # Enable X11 windowing system and GNOME desktop environment
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Modern NixOS 24.11+ display and desktop manager options
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Exclude unnecessary GNOME bloat
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-contacts
    gnome-maps
    epiphany # gnome web browser
    geary    # email client
  ];
}
