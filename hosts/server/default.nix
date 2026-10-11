{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/users/gianluca.nix
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/networking.nix
    ../../modules/nixos/services/openssh.nix
  ];

  networking.hostName = "server";

  # Enable container support
  virtualisation.docker.enable = true;
  users.users.gianluca.extraGroups = [ "docker" ];

  # Server specific system packages
  environment.systemPackages = with pkgs; [
    docker-compose
    tmux
    rsync
  ];
}
