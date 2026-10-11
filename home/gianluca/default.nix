{ pkgs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home.username = "gianluca";
  home.homeDirectory = "/home/gianluca";

  # Home Manager release version
  home.stateVersion = "26.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
