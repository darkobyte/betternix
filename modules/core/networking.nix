{ pkgs, env, ... }:
{
  networking = {
    hostName = env.hostname or "pulsar-node";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  environment.systemPackages = with pkgs; [
    geteduroam
    geteduroam-cli
  ];
}
