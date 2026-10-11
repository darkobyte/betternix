{ pkgs, ... }:

{
  imports = [
    ./default.nix
  ];

  # Server specific user packages (CLI only)
  home.packages = with pkgs; [
    tmux
    ncdu
    iftop
  ];
}
