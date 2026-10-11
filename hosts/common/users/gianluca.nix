{ pkgs, ... }:

{
  users.users.gianluca = {
    isNormalUser = true;
    description = "Gianluca";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" ];
    shell = pkgs.bash;
  };
}
