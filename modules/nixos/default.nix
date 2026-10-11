{ ... }:

{
  imports = [
    ./boot.nix
    ./networking.nix
    ./audio.nix
    ./services/openssh.nix
  ];
}
