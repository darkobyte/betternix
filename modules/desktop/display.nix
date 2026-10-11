{ pkgs, ... }:
{
  services.xserver.enable = false;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd mango-session";
        user = "greeter";
      };
    };
  };

  # Graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
