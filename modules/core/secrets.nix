{ lib, ... }:
let
  envPath = ../../.env.json;
  fallbackEnv = {
    username = "gianluca";
    fullName = "Gianluca";
    email = "gianluca@gmail.com";
    hostname = "dumbledore";
    timezone = "Europe/Rome";
    locale = "en_US.UTF-8";
  };
  env =
    if builtins.pathExists envPath
    then builtins.fromJSON (builtins.readFile envPath)
    else fallbackEnv;
in
{
  _module.args = {
    env = env;
  };
}
