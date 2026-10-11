{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    # Core system modules
    ../../modules/core/default.nix

    # Desktop stack
    ../../modules/desktop/default.nix

    # Applications
    ../../modules/apps/firefox.nix
    ../../modules/apps/discord.nix
    ../../modules/apps/spotify.nix

    # Gaming stack
    ../../modules/gaming/steam.nix
    ../../modules/gaming/wine.nix
    ../../modules/gaming/proton.nix

    # Hardware
    ../../modules/hardware/bluetooth.nix
  ];
}
