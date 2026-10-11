{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-antigravity-cli # provides 'agy' command
  ];
}
