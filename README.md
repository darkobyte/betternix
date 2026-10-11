# Modular Multi-Profile NixOS & Home Manager Configuration

A granular, modular NixOS and Home Manager flake configuration designed for multiple client machines (Desktop PC, Laptop, Server).

Every application and system component has its **own dedicated `.nix` file**, neatly sorted into domain-specific folders (`browsers/`, `editors/`, `ai/`, `media/`, `productivity/`, `gaming/`, `core/`, `services/`). In each profile, you decide exactly which applications and features are installed simply by importing their individual files.

---

## 📁 Repository Structure

```text
.
├── flake.nix                               # Flake inputs, host definitions & Home Manager wiring
├── flake.lock                              # Locked dependency revisions
├── hosts/                                  # Machine-specific configurations
│   ├── common/                             # Shared across all systems
│   │   ├── default.nix                     # Base nix settings, zram, locale, packages
│   │   └── users/
│   │       └── gianluca.nix                # System user declaration (groups, shell)
│   ├── desktop/                            # Desktop workstation host
│   │   ├── default.nix                     # Desktop host imports (GNOME, Steam, Audio)
│   │   └── hardware-configuration.nix      # Physical hardware configuration
│   ├── laptop/                             # Laptop host
│   │   ├── default.nix                     # Laptop host imports (Power management, etc.)
│   │   └── hardware-configuration.nix
│   └── server/                             # Headless server host
│       ├── default.nix                     # Server host imports (Docker, SSH)
│       └── hardware-configuration.nix
├── modules/                                # Reusable standalone modules (one file per item)
│   ├── nixos/                              # System-level modules
│   │   ├── core/                           # Core system functionality
│   │   │   ├── audio.nix                   # Pipewire & sound
│   │   │   ├── boot.nix                    # Systemd-boot EFI loader
│   │   │   └── networking.nix              # NetworkManager & firewall
│   │   ├── desktop/                        # Desktop environments
│   │   │   └── gnome.nix                   # GDM + GNOME desktop environment
│   │   ├── gaming/                         # System-level gaming
│   │   │   └── steam.nix                   # Steam (32-bit graphics drivers & firewall rules)
│   │   └── services/                       # Background services
│   │       └── openssh.nix                 # OpenSSH daemon
│   └── home/                               # User-level (Home Manager) modules
│       ├── ai/                             # AI Assistants & Agents
│       │   ├── agy.nix                     # Google Antigravity CLI ('agy')
│       │   └── opencode.nix                # OpenCode AI terminal agent
│       ├── browsers/                       # Web browsers
│       │   └── brave.nix                   # Brave Browser
│       ├── editors/                        # Code & text editors
│       │   ├── neovim.nix                  # Neovim
│       │   ├── vscode.nix                  # Visual Studio Code
│       │   └── zed.nix                     # Zed Editor
│       ├── gaming/                         # User gaming & compatibility
│       │   └── wine.nix                    # Wine (Wine-Wow64)
│       ├── media/                          # Audio & video
│       │   └── spotify.nix                 # Spotify
│       ├── productivity/                   # Cloud, passwords & office
│       │   ├── bitwarden.nix               # Bitwarden Desktop
│       │   ├── nextcloud.nix               # Nextcloud Client
│       │   └── onlyoffice.nix              # OnlyOffice Desktop Editors
│       ├── shell/                          # Shell & prompts
│       │   ├── bash.nix                    # Bash configuration
│       │   └── starship.nix                # Starship prompt
│       └── tools/                          # CLI utilities & VCS
│           ├── cli-tools.nix               # CLI utils (bat, eza, fzf, ripgrep, btop, jq)
│           └── git.nix                     # Git configuration
└── home/                                   # User profiles per machine type
    └── gianluca/
        ├── default.nix                     # Base profile shared across all profiles
        ├── desktop.nix                     # Desktop profile: imports all apps & wine
        ├── laptop.nix                      # Laptop profile: imports dev & productivity apps
        └── server.nix                      # Server profile: imports headless tools only
```

---

## 🎯 How App Selection Works

Each application lives in its own file under its corresponding category folder in `modules/home/`.

To install or uninstall an app from a profile, you simply add or remove its single import line.

### Example: Desktop Profile (`home/gianluca/desktop.nix`)
```nix
{ pkgs, ... }:

{
  imports = [
    ./default.nix

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
```

### Example: Laptop Profile (`home/gianluca/laptop.nix`)
On laptop, Wine is omitted to save battery and disk:
```nix
{ pkgs, ... }:

{
  imports = [
    ./default.nix

    # AI Assistants & Agents
    ../../modules/home/ai/agy.nix
    ../../modules/home/ai/opencode.nix

    # Browsers
    ../../modules/home/browsers/brave.nix

    # Code Editors
    ../../modules/home/editors/vscode.nix
    ../../modules/home/editors/zed.nix

    # Media & Audio
    ../../modules/home/media/spotify.nix

    # Productivity & Cloud
    ../../modules/home/productivity/bitwarden.nix
    ../../modules/home/productivity/nextcloud.nix
    ../../modules/home/productivity/onlyoffice.nix
  ];
}
```

### Example: Server Profile (`home/gianluca/server.nix`)
On server, only CLI utilities are imported:
```nix
{ pkgs, ... }:

{
  imports = [
    ./default.nix

    # CLI-only tools for Server:
    ../../modules/home/ai/agy.nix
    ../../modules/home/ai/opencode.nix
  ];
}
```

---

## ➕ How to Add a New Application

1. Create a new file in the appropriate category under `modules/home/<category>/<app-name>.nix`:
   ```nix
   { pkgs, ... }:

   {
     home.packages = with pkgs; [
       <package-name>
     ];
   }
   ```
   *(Or if Home Manager has dedicated configuration options for it, e.g. `programs.<name>.enable = true;`)*

2. Open the profile where you want the app installed (e.g. `home/gianluca/desktop.nix`) and add:
   ```nix
   ../../modules/home/<category>/<app-name>.nix
   ```

3. Stage your new file in git and verify:
   ```bash
   git add -A
   nix flake check
   ```

---

## 🖥️ How to Add a New Host

When you have a new computer (e.g. `workstation` or `homelab`):

### 1. Generate Hardware Configuration on the Target Machine
On the new machine, run:
```bash
nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### 2. Create the Host Folder
In `hosts/`, create a new folder:
```bash
mkdir -p hosts/workstation
```
Move the generated `hardware-configuration.nix` into `hosts/workstation/hardware-configuration.nix`.

### 3. Create `hosts/workstation/default.nix`
Create `hosts/workstation/default.nix` and pick the system modules you want:
```nix
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/users/gianluca.nix
    ../../modules/nixos/core/boot.nix
    ../../modules/nixos/core/networking.nix
    ../../modules/nixos/core/audio.nix
    ../../modules/nixos/desktop/gnome.nix
    ../../modules/nixos/services/openssh.nix
  ];

  networking.hostName = "workstation";
}
```

### 4. Register the Host in `flake.nix`
Add your host to `nixosConfigurations` in `flake.nix`:
```nix
nixosConfigurations = {
  desktop     = mkHost { hostName = "desktop"; };
  laptop      = mkHost { hostName = "laptop"; };
  server      = mkHost { hostName = "server"; };
  workstation = mkHost { hostName = "workstation"; homeProfile = "desktop"; };
};
```
*(You can map `homeProfile` to an existing profile like `"desktop"` or `"laptop"`, or create a custom `home/gianluca/workstation.nix`).*

### 5. Stage in Git & Apply
```bash
git add -A
nix flake check
sudo nixos-rebuild switch --flake .#workstation
```

---

## ⚡ Useful Commands

| Command | Action |
| :--- | :--- |
| `nix flake check` | Validate syntax & configuration across all hosts and profiles |
| `sudo nixos-rebuild switch --flake .#desktop` | Apply Desktop profile on the PC |
| `sudo nixos-rebuild switch --flake .#laptop` | Apply Laptop profile on the laptop |
| `sudo nixos-rebuild switch --flake .#server` | Apply Server profile on the server |
| `sudo nixos-rebuild switch --flake .` | Automatically apply profile matching current hostname |
| `nixos-rebuild build --flake .#desktop` | Dry build without switching running system |
