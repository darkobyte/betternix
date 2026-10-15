{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    # Core system modules
    ../../modules/core/default.nix
    ../../modules/dev/docker.nix


    # Desktop stack
    ../../modules/desktop/default.nix

    # Applications
    ../../modules/apps/firefox.nix
    ../../modules/apps/brave.nix
    ../../modules/apps/discord.nix
    ../../modules/apps/spotify.nix
    ../../modules/apps/zed.nix
    ../../modules/apps/obsidian.nix
    ../../modules/apps/screenshot.nix
    ../../modules/apps/nextcloud.nix
    ../../modules/apps/intellij.nix

    # Programming Languages
    ../../modules/languages/default.nix

    # Hardware (Power management + Bluetooth)
    ../../modules/hardware/power.nix
    ../../modules/hardware/bluetooth.nix
  ];
}
