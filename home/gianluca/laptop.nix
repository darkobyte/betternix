{ pkgs, ... }:

{
  imports = [
    ./default.nix
  ];

  # Laptop specific user packages
  home.packages = with pkgs; [
    firefox
    brightnessctl
  ];
}
