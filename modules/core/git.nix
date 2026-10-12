{ pkgs, ... }:
{
  programs.git = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    gh
  ];
}
