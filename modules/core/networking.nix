{ env, ... }:
{
  networking = {
    hostName = env.hostname or "pulsar-node";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
    };
  };
}
