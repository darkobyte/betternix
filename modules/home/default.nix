{ ... }:

{
  imports = [
    ./tools/git.nix
    ./tools/cli-tools.nix
    ./shell/bash.nix
    ./shell/starship.nix
    ./editors/neovim.nix
  ];
}
