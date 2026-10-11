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
    ../../modules/nixos/services/openssh.nix
  ];

  networking.hostName = "laptop";

  # Laptop power management & battery conservation
  services.power-profiles-daemon.enable = true;

  # Bluetooth support
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Laptop specific tools
  environment.systemPackages = with pkgs; [
    brightnessctl
    powertop
  ];
}
