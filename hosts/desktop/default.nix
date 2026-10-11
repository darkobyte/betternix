{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/users/gianluca.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/services/openssh.nix
  ];

  networking.hostName = "desktop";

  # Desktop specific system packages
  environment.systemPackages = with pkgs; [
    alacritty
  ];
}
