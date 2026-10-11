{ pkgs, ... }:
let
  # Mango WM Session Launcher script
  mangoSession = pkgs.writeShellScriptBin "mango-session" ''
    # Environment variables for Wayland session
    export XDG_CURRENT_DESKTOP=mango
    export XDG_SESSION_DESKTOP=mango
    export XDG_SESSION_TYPE=wayland
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland

    # Execute Mango Window Manager if present or fallback to river/sway/wayland compositor
    if command -v mango >/dev/null 2>&1; then
      exec mango
    elif command -v river >/dev/null 2>&1; then
      exec river
    else
      exec sway
    fi
  '';

  # Mango session package with providedSessions metadata for NixOS displayManager
  mangoSessionPackage = (pkgs.writeTextFile {
    name = "mango-wayland-session";
    destination = "/share/wayland-sessions/mango.desktop";
    text = ''
      [Desktop Entry]
      Name=Mango WM
      Comment=Modular Tiling Wayland Compositor
      Exec=${mangoSession}/bin/mango-session
      Type=Application
    '';
    passthru.providedSessions = [ "mango" ];
  });
in
{
  # Core Wayland & compositor support
  programs.river.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # Mango WM session desktop file & launcher
  services.displayManager.sessionPackages = [
    mangoSessionPackage
  ];

  # System package dependencies and Mango configuration file helper
  environment.systemPackages = with pkgs; [
    mangoSession
    foot
    fuzzel
    wlr-randr
    wl-clipboard
    brightnessctl
  ];

  # Generate Mango WM configuration with specified keybindings:
  # Super + Q close
  # Super + Enter terminal (foot)
  # Super + Space launcher (fuzzel)
  # Super + [1..9] workspaces
  environment.etc."mango/config.toml".text = ''
    # Mango WM Master Configuration
    [general]
    border_width = 2
    gaps_inner = 6
    gaps_outer = 10

    [keybindings]
    # Window management
    "Mod4+q" = "close"
    "Mod4+Return" = "spawn foot"
    "Mod4+space" = "spawn fuzzel"

    # Workspace switching
    "Mod4+1" = "workspace 1"
    "Mod4+2" = "workspace 2"
    "Mod4+3" = "workspace 3"
    "Mod4+4" = "workspace 4"
    "Mod4+5" = "workspace 5"
    "Mod4+6" = "workspace 6"
    "Mod4+7" = "workspace 7"
    "Mod4+8" = "workspace 8"
    "Mod4+9" = "workspace 9"

    # Move window to workspace
    "Mod4+Shift+1" = "send-to-workspace 1"
    "Mod4+Shift+2" = "send-to-workspace 2"
    "Mod4+Shift+3" = "send-to-workspace 3"
    "Mod4+Shift+4" = "send-to-workspace 4"
    "Mod4+Shift+5" = "send-to-workspace 5"
    "Mod4+Shift+6" = "send-to-workspace 6"
    "Mod4+Shift+7" = "send-to-workspace 7"
    "Mod4+Shift+8" = "send-to-workspace 8"
    "Mod4+Shift+9" = "send-to-workspace 9"
  '';
}
