{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    cmake
    pkg-config
    python3
    rustup
    go
    ninja
    gdb
  ];
}
