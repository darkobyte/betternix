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
    ../../modules/apps/zed.nix
    ../../modules/apps/opencode.nix

    # Dev stack
    ../../modules/dev/docker.nix
    ../../modules/dev/tools.nix

    # Hardware
    ../../modules/hardware/bluetooth.nix
  ];
}
