{ config, pkgs, env, ... }:
{
  home.username = env.username;
  home.homeDirectory = "/home/${env.username}";
  home.stateVersion = "24.11";

  # User packages
  home.packages = with pkgs; [
    eza
    bat
    fzf
    fastfetch
    lazygit
    google-antigravity-cli # Google Antigravity CLI (command: agy)
  ];

  # Zsh configuration and aliases
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --level=2 --icons";
      cat = "bat --paging=never";
      rebuild = "sudo nixos-rebuild switch --flake .";
      pulsar = "./pulsar.sh";
      gc = "nix-collect-garbage -d";
      zed = "zeditor";
    };
    initExtra = ''
      # PULSAR Environment
      if [ -z "$PULSAR_SHELL_INITIALIZED" ]; then
        export PULSAR_SHELL_INITIALIZED=1
      fi
    '';
  };

  # Starship prompt configuration
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
      directory = {
        style = "bold cyan";
        truncation_length = 3;
      };
      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold purple";
      };
    };
  };

  # Git user settings loaded from env
  programs.git = {
    enable = true;
    userName = env.fullName or "Gianluca";
    userEmail = env.email or "gianluca@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # User dotfiles: Foot terminal config
  xdg.configFile."foot/foot.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=11
    pad=12x12

    [colors]
    alpha=0.92
    background=0b0f19
    foreground=e2e8f0
  '';

  # User dotfiles: Fuzzel application launcher config
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=12
    prompt="❯ "
    terminal=foot -e
    lines=8
    width=35
    horizontal-pad=20
    vertical-pad=15
    inner-pad=10

    [colors]
    background=0b0f19f0
    text=e2e8f0ff
    match=38bdf8ff
    selection=1e293bff
    selection-text=38bdf8ff
    border=38bdf8ff
  '';

  programs.home-manager.enable = true;
}
