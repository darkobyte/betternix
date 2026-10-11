{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    cmake
    pkg-config
    python3
    nodejs
    rustup
    go
    htop
    ripgrep
    fd
    tree
    unzip
  ];
}
