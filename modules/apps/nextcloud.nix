{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nextcloud-client
  ];

  # Keyring backend required by Nextcloud client to securely persist account tokens
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
