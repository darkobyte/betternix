{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Gianluca";
        email = "gianluca@example.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
