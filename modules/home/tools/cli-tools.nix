{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    btop
    eza
    fastfetch
    fd
    fzf
    jq
    ripgrep
    tree
  ];

  # Modern alias replacements
  home.shellAliases = {
    ls = "eza --icons";
    ll = "eza -l --icons --git";
    la = "eza -la --icons --git";
    cat = "bat --paging=never";
  };
}
