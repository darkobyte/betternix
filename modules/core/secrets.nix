{ lib, ... }:
let
  envPath = ../../.env.json;
  fallbackEnv = {
    username = "pulsar";
    fullName = "Pulsar Administrator";
    email = "pulsar@example.com";
    hostname = "pulsar-node";
    timezone = "UTC";
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
