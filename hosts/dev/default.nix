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
    ../../modules/apps/brave.nix
    ../../modules/apps/dolphin.nix
    ../../modules/apps/zed.nix
    ../../modules/apps/intellij.nix
    ../../modules/apps/opencode.nix

    # Dev & Languages stack
    ../../modules/dev/default.nix
    ../../modules/languages/default.nix

    # Hardware
    ../../modules/hardware/bluetooth.nix
  ];
}
