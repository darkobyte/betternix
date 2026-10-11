{ ... }:
{
  imports = [
    ./secrets.nix
    ./system.nix
    ./users.nix
    ./networking.nix
    ./audio.nix
    ./git.nix
  ];
}
