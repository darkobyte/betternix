{ ... }:

{
  imports = [
    ./core/boot.nix
    ./core/networking.nix
    ./core/audio.nix
    ./services/openssh.nix
  ];
}
