{ pkgs, ... }:

{
  # Enable MangoWC (Wayland compositor based on dwl)
  programs.mango = {
    enable = true;
  };

  # Set Mango as the default login session
  services.displayManager.defaultSession = "mango";

  # Noctalia desktop shell and Wayland utilities
  environment.systemPackages = with pkgs; [
    noctalia          # Modern desktop shell for Wayland (bar, launcher, widgets)
    wl-clipboard      # Clipboard management for Wayland
    swaybg            # Wayland wallpaper tool
    fuzzel            # Lightweight Wayland app launcher
    alacritty         # Terminal emulator
  ];
}
