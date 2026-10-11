{ ... }:

{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowPing = true;
  };
}
