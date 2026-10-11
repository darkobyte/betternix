{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/users/gianluca.nix
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/networking.nix
    ../../modules/nixos/core/audio.nix
    ../../modules/nixos/desktop/gnome.nix
    ../../modules/nixos/gaming/steam.nix
    ../../modules/nixos/services/openssh.nix
  ];

  networking.hostName = "desktop";

  # Desktop specific system packages
  environment.systemPackages = with pkgs; [
    alacritty
  ];
}
