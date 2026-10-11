{ pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Ensure DNS resolution works correctly with NetworkManager
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.resolvconf.useLocalResolver = false;

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedUDPPorts = [ 53 67 68 ]; # DHCP/DNS
    allowedTCPPorts = [ 53 ];       # DNS
  };
}
