{ pkgs, ... }:

{
  # Enable MangoWC (Wayland compositor based on dwl)
  programs.mango = {
    enable = true;
  };

  # Set Mango as the default login session
  services.displayManager.defaultSession = "mango";

  # Runtime dependencies for a functional Mango desktop
  environment.systemPackages = with pkgs; [
    # Core UI Tools
    foot              # Default terminal for mango config
    rofi              # Application launcher
    waybar            # Status bar
    polkit_gnome      # Authentication agent (for sudo/GUI apps)
    
    # Utilities
    wl-clipboard      # Clipboard management
    wlsunset          # Gamma control / night light
    brightnessctl     # Screen brightness
    
    # Session Management
    wlogout           # Simple logout dialog
  ];
}
