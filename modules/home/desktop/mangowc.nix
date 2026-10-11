{ pkgs, ... }:

{
  home.packages = with pkgs; [
    noctalia
  ];

  # Autostart Noctalia shell with MangoWC
  xdg.configFile."mango/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Kill any lingering instances
      pkill noctalia

      # Start Noctalia desktop shell (bar, widgets, notifications)
      noctalia &
    '';
  };
}
