{ pkgs, ... }:

{
  imports = [
    ./noctalia.nix
    ./foot.nix
    ./rofi.nix
    ./waybar.nix
    ./polkit.nix
    ./logout-manager.nix
    ./wlsunset.nix
    ./swaybg.nix
    ./grim-slurp.nix
  ];

  # Mango Configuration File
  xdg.configFile."mango/config.conf".text = ''
    # Mango Default Config with Noctalia Shell
    
    # Variables
    var=term,foot
    var=launcher,noctalia-launcher
    var=shell,noctalia
    
    # Appearance
    border_size=2
    gap_outer=8
    gap_inner=4
    focus_follows_mouse=yes
    warp_focus_on_click=yes
    
    # Colors (Default Gruvbox-ish)
    color_normal=#3C3836
    color_focused=#EBDBB2
    color_active=#A89984
    color_urgent=#FB4934
    
    # Bindings
    # Alt+Enter: Open Terminal
    bind=ALT,Return,spawn,$term
    
    # Alt+Space: Open Launcher (Noctalia integrated)
    bind=ALT,space,spawn,$launcher
    
    # Alt+Q: Close Window
    bind=ALT,q,killclient
    
    # Super+M: Quit Mango
    bind=SUPER,m,quit
    
    # Super+F: Toggle Fullscreen
    bind=SUPER,f,togglefullscreen
    
    # Arrow Keys: Move Focus
    bind=ALT,left,focusleft
    bind=ALT,right,focusright
    bind=ALT,up,focusup
    bind=ALT,down,focusdown
    
    # Tags (Workspaces)
    # Ctrl+1-9: Switch Tag
    bind=CTRL,1,settag,1
    bind=CTRL,2,settag,2
    bind=CTRL,3,settag,3
    bind=CTRL,4,settag,4
    bind=CTRL,5,settag,5
    bind=CTRL,6,settag,6
    bind=CTRL,7,settag,7
    bind=CTRL,8,settag,8
    bind=CTRL,9,settag,9
    
    # Alt+1-9: Move Window to Tag
    bind=ALT,1,movetag,1
    bind=ALT,2,movetag,2
    bind=ALT,3,movetag,3
    bind=ALT,4,movetag,4
    bind=ALT,5,movetag,5
    bind=ALT,6,movetag,6
    bind=ALT,7,movetag,7
    bind=ALT,8,movetag,8
    bind=ALT,9,movetag,9
    
    # Screenshots
    bind=SUPER,Print,spawn_shell,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png
    
    # Autostart
    exec_once=$shell
    exec_once=${pkgs.wlsunset}/bin/wlsunset -t 4000 -T 6500
    exec_once=${pkgs.swaybg}/bin/swaybg -i ~/Pictures/wallpaper.jpg -m fill || true
  '';
}
