{ pkgs, ... }:

{
  imports = [
    ./default.nix

    # AI Assistants & Agents (CLI)
    ../../modules/home/ai/agy.nix
    ../../modules/home/ai/opencode.nix
  ];

  # Server specific user packages (CLI only)
  home.packages = with pkgs; [
    tmux
    ncdu
    iftop
  ];
}
