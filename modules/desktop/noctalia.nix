{ config, pkgs, lib, inputs, ... }:
let
  noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Enable Noctalia - Wayland desktop shell, bar, and control center
  programs.noctalia = {
    enable = true;
    package = noctaliaPkg;
    systemd.enable = true;
    recommendedServices.enable = false;
  };

  # Global system-wide Noctalia configuration
  # Full-width topbar (not dock), clean minimal icons, no text clutter, dark mode
  environment.etc."noctalia/config.toml".text = ''
    [shell]
    corner_radius_scale = 1.0
    font_family = "JetBrainsMono Nerd Font"
    time_format = "{:%H:%M:%S}"
    telemetry_enabled = false
    clipboard_enabled = true

    [shell.animation]
    enabled = true
    speed = 1.2

    [shell.shadow]
    direction = "down"
    alpha = 0.4

    [shell.panel]
    transparency_mode = "glass"
    borders = false
    border_width = 0.0
    shadow = true
    launcher_placement = "floating"
    clipboard_placement = "floating"
    control_center_placement = "attached"
    launcher_position = "center"
    clipboard_position = "center"

    [shell.launcher]
    width = 640
    search_position = "top"
    default_view = "all_apps"
    category_icons_only = true
    show_settings_button = true
    show_session_button = true
    show_icons = true
    show_app_origin_indicator = false
    compact = true
    sort_by_usage = true

    [shell.window_switcher]
    style = "compact"
    current_workspace_only = false
    show_all_outputs = true
    show_app_icon = true
    show_caption = true
    show_count = true

    [theme]
    mode = "dark"
    source = "builtin"
    builtin = "Noctalia"
    pure_black_dark = true

    # Full Top Bar (Edge-to-edge, clean, minimal icons only, no text labels)
    [bar.main]
    position = "top"
    thickness = 36
    background_opacity = 0.85
    compositor_blur = true
    radius = 0
    margin_ends = 0
    margin_edge = 0
    padding = 16
    widget_spacing = 10
    scale = 1.0
    font_scale = 1.0
    shadow = false
    auto_hide = false
    reserve_space = true
    capsule = false

    # Only essential modules: clean workspaces, centered clock, minimal system indicators
    start = ["launcher", "workspaces"]
    center = ["clock"]
    end = ["tray", "volume", "brightness", "battery", "control-center"]

    # Dock disabled so it stays exclusively as a clean full topbar
    [dock]
    enabled = false

    [notification]
    enable_daemon = true
    show_app_name = true
    layer = "top"
    background_opacity = 0.90
    border = false
    border_width = 0

    [osd]
    position = "top_right"
    orientation = "horizontal"
    background_opacity = 0.90
    border = false
    border_width = 0

    [widget.network]
    show_label = false
    show_vpn_label = false

    [widget.clock]
    format = "{:%H:%M}"
    interactive = true

    [widget.workspaces]
    style = "regular"
    focused_color = "#ffffff"
    occupied_color = "#334155"
    empty_color = "#1e293b"
    urgent_color = "#ef4444"
  '';

  # Enable required services individually for NixOS 24.11 compatibility
  networking.networkmanager.enable = lib.mkDefault true;
  hardware.bluetooth.enable = lib.mkDefault true;
  services.upower.enable = lib.mkDefault true;

  environment.systemPackages = [
    noctaliaPkg
  ];
}
