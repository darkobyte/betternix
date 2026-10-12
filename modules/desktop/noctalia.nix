{ config, pkgs, lib, inputs, ... }:
let
  noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  # Enable Noctalia - A sleek Wayland desktop shell, bar, and control center
  programs.noctalia = {
    enable = true;
    package = noctaliaPkg;
    systemd.enable = true;
    recommendedServices.enable = false;
  };

  # Enable required services individually for NixOS 24.11 compatibility
  networking.networkmanager.enable = lib.mkDefault true;
  hardware.bluetooth.enable = lib.mkDefault true;
  services.upower.enable = lib.mkDefault true;

  environment.systemPackages = [
    noctaliaPkg
  ];
}
