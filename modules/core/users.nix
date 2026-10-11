{ pkgs, env, ... }:
{
  users.mutableUsers = true;

  users.users.${env.username} = {
    isNormalUser = true;
    description = env.fullName or "Pulsar Administrator";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
