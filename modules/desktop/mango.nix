{ pkgs, ... }:
let
  # Mango WM Session Launcher script
  mangoSession = pkgs.writeShellScriptBin "mango-session" ''
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
    export GDK_BACKEND=wayland
    export NIXOS_OZONE_WL=1

    if command -v mango >/dev/null 2>&1; then
      exec mango
    elif command -v swayfx >/dev/null 2>&1; then
      exec swayfx -c /etc/mango/sway.conf
    else
      exec sway -c /etc/mango/sway.conf
    fi
  '';

  # Mango session package with providedSessions metadata for NixOS displayManager
  mangoSessionPackage = (pkgs.writeTextFile {
    name = "mango-wayland-session";
    destination = "/share/wayland-sessions/mango.desktop";
    text = ''
      [Desktop Entry]
      Name=Mango WM
      Comment=Modular Tiling Wayland Compositor (PULSAR)
      Exec=${mangoSession}/bin/mango-session
      Type=Application
    '';
    passthru.providedSessions = [ "mango" ];
  });
in
{
  # Core Wayland & compositor support (SwayFX provides rounded corners, blur, and modern aesthetics)
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      autotiling
    ];
  };

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
    pkgs.swayfx
    mangoSession
    foot
    fuzzel
    wlr-randr
    wl-clipboard
    brightnessctl
    swaybg
  ];

  # Mango WM master compositor configuration:
  # Ultra-clean dark aesthetics, 0 border, subtle corner radius, gaps
  # Super + Q close
  # Super + Enter terminal (foot)
  # Super + Space launcher (fuzzel)
  # Super + [1..9] workspaces
  environment.etc."mango/sway.conf".text = ''
    # Mango WM Master Compositor Configuration
    set $mod Mod4

    # Typography
    font pango:JetBrainsMono Nerd Font 10

    # Output / Wallpaper & Display Scaling
    output * bg /etc/pulsar/wallpaper.png fill
    output eDP-1 scale 1.6

    # Autostart Noctalia desktop shell
    exec_always noctalia

    # Touchpad gestures & input
    input type:touchpad {
      tap enabled
      natural_scroll enabled
    }

    # Window Borders & Corner Radius (Ultra Clean Minimalist)
    default_border none
    default_floating_border none
    smart_borders on
    smart_gaps off

    # Margins and gaps (Consistent spacing on all sides, even with 1 window)
    gaps inner 8
    gaps outer 8

    # Rounded corners (SwayFX)
    corner_radius 10

    # Shadows & blur (SwayFX eye-candy)
    shadows on
    shadow_blur_radius 15
    shadow_color #00000099
    blur on
    blur_passes 3
    blur_radius 5

    # Color palette (Deep Minimalist Dark Mode - No bright border lines)
    client.focused          #00000000 #0b0f19 #e2e8f0 #00000000 #00000000
    client.focused_inactive #00000000 #0b0f19 #94a3b8 #00000000 #00000000
    client.unfocused        #00000000 #0b0f19 #64748b #00000000 #00000000

    # Core Keybindings
    bindsym $mod+Return exec foot
    bindsym $mod+space exec fuzzel
    bindsym $mod+q kill
    bindsym $mod+Shift+q exit
    bindsym $mod+Shift+c reload

    # Workspace navigation
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9

    # Move containers to workspaces
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9

    # Volume and brightness keys
    bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindsym XF86MonBrightnessUp exec brightnessctl set +5%
    bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

    # Screenshot shortcuts (Super+Shift+S region edit, Super+Shift+P fullscreen, Super+Ctrl+S quick area)
    bindsym --to-code $mod+Shift+s exec screenshot edit
    bindsym --to-code $mod+Shift+p exec screenshot fullscreen
    bindsym --to-code $mod+Ctrl+s exec screenshot area
    bindsym Print exec screenshot fullscreen
    bindsym Shift+Print exec screenshot edit
    bindsym Ctrl+Print exec screenshot area
  '';

  # Keep config.toml as specified
  environment.etc."mango/config.toml".text = ''
    [general]
    border_width = 0
    gaps_inner = 8
    gaps_outer = 8

    [keybindings]
    "Mod4+q" = "close"
    "Mod4+Return" = "spawn foot"
    "Mod4+space" = "spawn fuzzel"
    "Mod4+Shift+s" = "spawn screenshot edit"
    "Mod4+Shift+p" = "spawn screenshot fullscreen"
    "Mod4+Ctrl+s" = "spawn screenshot area"
    "Mod4+1" = "workspace 1"
    "Mod4+2" = "workspace 2"
    "Mod4+3" = "workspace 3"
    "Mod4+4" = "workspace 4"
    "Mod4+5" = "workspace 5"
    "Mod4+6" = "workspace 6"
    "Mod4+7" = "workspace 7"
    "Mod4+8" = "workspace 8"
    "Mod4+9" = "workspace 9"
  '';
}
