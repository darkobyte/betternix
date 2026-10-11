{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    gh
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "darkobyte";
        email = "darkobyte@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
