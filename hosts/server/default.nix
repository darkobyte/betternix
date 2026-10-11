{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    # Core system modules (Server runs headless core)
    ../../modules/core/default.nix

    # Dev / container runtime
    ../../modules/dev/docker.nix
  ];

  # Server-specific enhancements
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
