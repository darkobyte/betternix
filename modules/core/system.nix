{ config, pkgs, env, ... }:
{
  system.stateVersion = "24.11";

  time.timeZone = env.timezone or "UTC";
  i18n.defaultLocale = env.locale or "en_US.UTF-8";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" env.username ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    vim
    pciutils
    usbutils
    jq
  ];
}
