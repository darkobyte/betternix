{ pkgs, ... }:

let
  # Pin the Node.js version you want to use everywhere in this module
  nodePkg = pkgs.nodejs_22; # or pkgs.nodejs_20, pkgs.nodejs (current LTS)
in
{
  # System-wide packages for Node.js and its ecosystem
  environment.systemPackages = with pkgs; [
    nodePkg

    # Node Package Managers & Runtimes
    corepack        # Official tool to manage npm/yarn/pnpm versions per project
    nodePackages.npm
    nodePackages.pnpm
    yarn
    bun             # Modern, fast alternative runtime & package manager

    # Common build tools required for compiling native npm addons (node-gyp)
    gnumake
    gcc
    python3
  ];

  # Environment variables for global packages and tooling
  environment.sessionVariables = {
    # Where global packages install binaries (e.g. npm install -g <pkg>)
    # Avoids needing sudo for global installs
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";

    # Ensure native build tools find Python
    PYTHON = "${pkgs.python3}/bin/python3";
  };

  # Automatically put user-level global binaries into PATH
  environment.extraInit = ''
    export PATH="$HOME/.npm-global/bin:$HOME/.local/share/pnpm:$HOME/.bun/bin:$PATH"
  '';
}
