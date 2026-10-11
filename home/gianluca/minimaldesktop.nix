{ pkgs, ... }:

{
  imports = [
    ./default.nix

    # Desktop Shell / Compositor Config (MangoWC + Noctalia)
    ../../modules/home/desktop/mangowc.nix

    ../../modules/home/editors/zed.nix

    ../../modules/home/ai/opencode.nix

    ../../modules/home/browsers/brave.nix
  ];

  # Basic hardware / desktop utility
  home.packages = with pkgs; [
    brightnessctl
  ];
}
