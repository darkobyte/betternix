{ pkgs, ... }:

{
  home.packages = with pkgs; [
    noctalia
  ];
}
