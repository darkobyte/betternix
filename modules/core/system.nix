{ config, pkgs, env, ... }:
{
  system.stateVersion = "24.11";

  time.timeZone = env.timezone or "Europe/Rome";
  i18n.defaultLocale = env.locale or "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

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
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };

  # Framework AMD & hardware support
  hardware.enableRedistributableFirmware = true;
  services.udev.extraRules = ''
    # Arduino Opta bootloader
    SUBSYSTEM=="usb", ATTR{idVendor}=="2341", ATTR{idProduct}=="0364", MODE="0666"
  '';

  environment.systemPackages = with pkgs; [
    curl
    wget
    vim
    pciutils
    usbutils
    jq
  ];
}
