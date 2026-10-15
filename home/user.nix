{ config, pkgs, env, ... }:
{
  home.username = env.username;
  home.homeDirectory = "/home/${env.username}";
  home.stateVersion = "24.11";

  # User packages
  home.packages = with pkgs; [
    eza
    bat
    fzf
    fastfetch
    lazygit
    google-antigravity-cli # Google Antigravity CLI (command: agy)
  ];

  # Zsh configuration and aliases
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --level=2 --icons";
      cat = "bat --paging=never";
      rebuild = "sudo nixos-rebuild switch --flake .";
      pulsar = "./pulsar.sh";
      gc = "nix-collect-garbage -d";
      zed = "zeditor";
    };
    initExtra = ''
      # PULSAR Environment
      if [ -z "$PULSAR_SHELL_INITIALIZED" ]; then
        export PULSAR_SHELL_INITIALIZED=1
      fi
    '';
  };

  # Starship prompt configuration (Clean & minimal)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$character";
      directory = {
        style = "bold cyan";
        truncation_length = 3;
      };
      character = {
        success_symbol = "[❯](bold green) ";
        error_symbol = "[❯](bold red) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold purple";
      };
    };
  };

  # Git user settings loaded from env
  programs.git = {
    enable = true;
    userName = env.fullName or "Gianluca";
    userEmail = env.email or "gianluca@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      credential."https://github.com".helper = "!gh auth git-credential";
      credential."https://gist.github.com".helper = "!gh auth git-credential";
    };
  };

  # User dotfiles: Foot terminal config (Clean dark mode with rounded corners)
  xdg.configFile."foot/foot.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=11
    pad=16x16

    [colors]
    alpha=0.94
    background=0b0f19
    foreground=e2e8f0
  '';

  # User dotfiles: Fuzzel application launcher config (Rounded corners, no harsh borders, clean dark theme)
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=12
    prompt="  ❯ "
    terminal=foot -e
    lines=8
    width=32
    horizontal-pad=24
    vertical-pad=18
    inner-pad=12

    [border]
    width=1
    radius=12

    [colors]
    background=0b0f19fa
    text=e2e8f0ff
    match=38bdf8ff
    selection=1e293bff
    selection-text=38bdf8ff
    border=334155ff
  '';

  # System GTK Theme (Forces dark mode for GTK applications and desktop portals)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze-icons;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # FreeDesktop / GNOME Portal color-scheme preference
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "breeze-dark";
    };
  };

  # User dotfiles: KDE / Qt apps globals (ensures Dolphin uses breeze-dark icons & dark mode)
  xdg.configFile."kdeglobals".text = ''
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

  # User dotfiles: Sync Noctalia config into ~/.config/noctalia/config.toml
  xdg.configFile."noctalia/config.toml".text = ''
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

    # Full Edge-to-Edge Top Bar: 0 radius, 0 margins, clean icons only, no text labels
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

    # Only essential icons: launcher, workspaces, clock, tray, and quick sliders
    start = ["launcher", "workspaces"]
    center = ["clock"]
    end = ["tray", "volume", "brightness", "battery", "control-center"]

    # Disable dock mode
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

  programs.home-manager.enable = true;
}
