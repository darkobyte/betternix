{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    # Core system modules
    ../../modules/core/default.nix

    # Desktop stack (Mango WM, Noctalia, Screenshot tool)
    ../../modules/desktop/default.nix

    # Applications
    ../../modules/apps/firefox.nix
    ../../modules/apps/brave.nix
    ../../modules/apps/dolphin.nix
    ../../modules/apps/discord.nix
    ../../modules/apps/spotify.nix
    ../../modules/apps/zed.nix
    ../../modules/apps/obsidian.nix
    ../../modules/apps/nextcloud.nix
    ../../modules/apps/intellij.nix

    # Development & Programming Languages
    ../../modules/dev/default.nix
    ../../modules/languages/default.nix

    # Hardware (Power management + Bluetooth)
    ../../modules/hardware/default.nix
  ];
}
