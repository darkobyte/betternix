{ pkgs, ... }:

{
  imports = [
    ./default.nix
  ];

  # Desktop specific user packages
  home.packages = with pkgs; [
    # General Desktop & Dev tools
    firefox
    git
    vlc
  ];
}
