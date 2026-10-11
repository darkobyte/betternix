{ pkgs, ... }:

{
  imports = [
    ./default.nix

    # Desktop Shell / Compositor Config (MangoWC + Noctalia)
    ../../modules/home/desktop/mangowc.nix
  ];

  # Basic hardware / desktop utility
  home.packages = with pkgs; [
    brightnessctl
  ];
}
