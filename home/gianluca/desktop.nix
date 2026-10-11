{ pkgs, ... }:

{
  imports = [
    ./default.nix

    # Desktop Shell / Compositor Config
    ../../modules/home/desktop/mangowc.nix

    # AI Assistants & Agents
    ../../modules/home/ai/agy.nix
    ../../modules/home/ai/opencode.nix

    # Browsers
    ../../modules/home/browsers/brave.nix

    # Code Editors
    ../../modules/home/editors/vscode.nix
    ../../modules/home/editors/zed.nix

    # Gaming & Compatibility
    ../../modules/home/gaming/wine.nix

    # Media & Audio
    ../../modules/home/media/spotify.nix

    # Productivity & Cloud
    ../../modules/home/productivity/bitwarden.nix
    ../../modules/home/productivity/nextcloud.nix
    ../../modules/home/productivity/onlyoffice.nix
  ];
}
