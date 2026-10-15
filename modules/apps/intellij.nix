{ pkgs, ... }:
let
  ideaWrapper = pkgs.writeShellScriptBin "intellij" ''
    exec ${pkgs.jetbrains.idea-community}/bin/idea-community "$@"
  '';
in
{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-community
    ideaWrapper
  ];
}
