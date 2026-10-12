{ pkgs, env, ... }:
{
  # users.mutableUsers = true ensures that system activation never resets or alters passwords
  users.mutableUsers = true;

  users.users.${env.username} = {
    isNormalUser = true;
    description = env.fullName or "Gianluca";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "input"
      "dialout"
      "uucp"
      "plugdev"
      "audio"
    ];
    linger = true;
  };

  programs.zsh.enable = true;
}
