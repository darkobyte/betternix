{ pkgs, ... }:
{
  services.xserver.enable = false;

  # Console-based tuigreet login screen on tty1
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd mango-session";
        user = "greeter";
      };
    };
  };

  # Graphics acceleration for AMD Phoenix / modern GPUs
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
