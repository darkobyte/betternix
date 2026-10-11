{ pkgs, ... }:
let
  # VSCodium / Open Source VS Code IDE wrapper
  opencodePkg = pkgs.vscodium;
in
{
  environment.systemPackages = [
    opencodePkg
  ];
}
