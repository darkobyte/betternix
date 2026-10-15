{ pkgs, ... }:
{
  # Java Development Kit (OpenJDK 21 LTS)
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  environment.systemPackages = with pkgs; [
    jdk21
    maven
    gradle
  ];

  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };
}
