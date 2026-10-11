{ pkgs, ... }:

{
  # Enable Flakes and modern nix command
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  # Automatic Nix store garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Localization and Timezone
  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
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

  # Console keymap
  console.keyMap = "us";

  # Memory compression via zram
  zramSwap.enable = true;

  # Essential system-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    pciutils
    usbutils
    tree
  ];

  # System state version
  system.stateVersion = "26.05";
}
