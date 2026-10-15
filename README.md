# 🌌 PULSAR: Systemic Modular NixOS & Deployment Framework

<p align="center">
  <img src="https://img.shields.io/badge/NixOS-24.11_Stable-blue?logo=nixos&logoColor=white&style=for-the-badge" alt="NixOS Version" />
  <img src="https://img.shields.io/badge/Home_Manager-Integrated-teal?logo=nixos&logoColor=white&style=for-the-badge" alt="Home Manager" />
  <img src="https://img.shields.io/badge/Desktop-Mango_WM-orange?style=for-the-badge" alt="Desktop WM" />
  <img src="https://img.shields.io/badge/Shell_Bar-Noctalia-purple?style=for-the-badge" alt="Desktop Shell" />
  <img src="https://img.shields.io/badge/Architecture-Modular_Isolation-emerald?style=for-the-badge" alt="Architecture" />
</p>

```
██████╗ ██╗   ██╗██╗     ███████╗ █████╗ ██████╗ 
██╔══██╗██║   ██║██║     ██╔════╝██╔══██╗██╔══██╗
██████╔╝██║   ██║██║     ███████╗███████║██████╔╝
██╔═══╝ ██║   ██║██║     ╚════██║██╔══██║██╔══██╗
██║     ╚██████╔╝███████╗███████║██║  ██║██║  ██║
╚═╝      ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
```

> **PULSAR** is an enterprise-grade, flake-based modular NixOS framework designed for declarative system isolation, rock-solid security, reproducible dotfiles, and zero-leak environment secret segregation.

---

## ⚡ Highlights & Key Features

* 🧩 **Strict Concern Isolation:** Every service, desktop tool, GUI program, and hardware profile lives in its own standalone `.nix` file under `modules/`.
* 🛡️ **Zero Secret Leakage:** Dynamic environment variables and identity credentials are ingested exclusively at evaluation time via `.env.json`, keeping personal data completely out of Git version history.
* 🪟 **Next-Gen Wayland Desktop:** Features **Mango WM** with native tiling, custom workspace keybinds, and **Noctalia** desktop shell integration.
* 📦 **Integrated Home Manager:** Complete declarative user lifecycle orchestration (`home/user.nix`), powering Zsh aliases, Starship prompt, and terminal theming.
* 🧪 **Automated Build Safeguards:** Built-in dry-run evaluation and flake health checks ensure system definitions compile cleanly before applying any live modifications.
* 🖥️ **Interactive Terminal UI:** Complete terminal manager (`pulsar.sh`) providing centered dialogs for environment customization, store optimization, and target deployment.

---

## 🔐 Dynamic Secrets & Environment Isolation

In traditional NixOS setups, user identities, hostnames, and credentials often leak into public Git repositories. **PULSAR** enforces a zero-trust model:

```
                  ┌──────────────────────┐
                  │   .env.json.example  │ (Tracked in Git, sanitized)
                  └──────────┬───────────┘
                             │ copy / customize
                             ▼
┌──────────────┐   eval   ┌──────────────┐   eval   ┌───────────────────────────┐
│  modules/*   │ ◄─────── │  .env.json   │ ───────► │ home/user.nix & flake.nix │
└──────────────┘          └──────────────┘          └───────────────────────────┘
                           (Ignored in Git)
```

1. **`.env.json.example`** provides a tracked, non-sensitive template.
2. Real machine parameters reside in **`.env.json`**, strictly listed in `.gitignore`.
3. System and home expressions read this configuration on-the-fly via `builtins.fromJSON (builtins.readFile ./.env.json)`, preserving git sanitization.

---

## 🎯 Target Profile Matrix

PULSAR provides 5 distinct profiles tailored for specialized system workloads:

| Module / Component | Workstation | Gaming | Dev | Laptop | Server |
| :--- | :---: | :---: | :---: | :---: | :---: |
| `modules/core/*` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `modules/desktop/*` (Mango + Noctalia + Satty) | ✅ | ✅ | ✅ | ✅ | ❌ |
| `modules/apps/firefox.nix` | ✅ | ✅ | ✅ | ✅ | ❌ |
| `modules/apps/brave.nix` | ✅ | ❌ | ✅ | ✅ | ❌ |
| `modules/apps/dolphin.nix` | ✅ | ✅ | ✅ | ✅ | ❌ |
| `modules/apps/discord.nix` | ✅ | ✅ | ❌ | ✅ | ❌ |
| `modules/apps/spotify.nix` | ✅ | ✅ | ❌ | ✅ | ❌ |
| `modules/apps/zed.nix` | ✅ | ❌ | ✅ | ✅ | ❌ |
| `modules/apps/opencode.nix` | ❌ | ❌ | ✅ | ❌ | ❌ |
| `modules/apps/obsidian.nix` | ✅ | ❌ | ❌ | ✅ | ❌ |
| `modules/apps/nextcloud.nix` | ✅ | ❌ | ❌ | ✅ | ❌ |
| `modules/apps/intellij.nix` | ✅ | ❌ | ✅ | ✅ | ❌ |
| `modules/languages/*` (Java, Node) | ✅ | ❌ | ✅ | ✅ | ❌ |
| `modules/gaming/*` (Steam, Wine, Proton) | ❌ | ✅ | ❌ | ❌ | ❌ |
| `modules/dev/*` (Docker, Compilers) | ✅ | ❌ | ✅ | ✅ | ✅ |
| `modules/hardware/power.nix` | ❌ | ❌ | ❌ | ✅ | ❌ |
| `modules/hardware/bluetooth.nix` | ✅ | ✅ | ✅ | ✅ | ❌ |

---

## ⌨️ Mango WM Keybindings

| Key Combination | Function | Description |
| :--- | :--- | :--- |
| `Super + Return` | Launch Terminal | Opens `foot` terminal emulator |
| `Super + Space` | Application Launcher | Opens `fuzzel` launcher |
| `Super + E` | File Manager | Opens `dolphin` file manager |
| `Super + Tab` / `Alt + Tab` | Window Switcher | Opens `noctalia` interactive window switcher overlay |
| `Super + Q` | Close Window | Closes focused Wayland client |
| `Super + S` | Toggle Tiling / Stacking | Switches between dynamic Tiling and Stacking/Scrolling layout |
| `Super + W` | Toggle Tabbed Layout | Switches between Tiling and Tabbed layout |
| `Super + F` | Toggle Fullscreen | Maximizes focused window to fullscreen |
| `Super + [1..9]` | Switch Workspace | Navigates directly to workspace `1` through `9` |
| `Super + Shift + [1..9]` | Move & Follow Workspace | Sends focused client to workspace and switches to it immediately |
| `Super + Shift + Arrows` / `HJKL` | Move Window | Moves window position within layout |
| `Super + Shift + S` | Fast Screenshot (Annotate) | Captures region, copies to clipboard, opens `satty` instantly |
| `Super + Ctrl + S` | Instant Area Snip | Captures region directly to clipboard and disk without opening editor |
| `Super + Shift + P` / `Print` | Fullscreen Screenshot | Captures full screen to clipboard and disk |

---

## 🚀 Quickstart Guide

### 1. Clone & Initialize Configuration
```bash
git clone <your-repo-url> ~/nixos-config
cd ~/nixos-config
cp .env.json.example .env.json
```

### 2. Configure Environment Parameters
Edit `.env.json` with your real username, hostname, and preferences, or launch the interactive wizard:
```bash
./pulsar.sh
# Select [4] Configure Environment Variables
```

### 3. Verify System Build Safely
Verify that the target derivation compiles cleanly without touching your running system:
```bash
./pulsar.sh
# Select [2] Test & Verify Build
```

### 4. Deploy Configuration
```bash
./pulsar.sh
# Select [1] Start Full System Setup
```
Or manually via standard NixOS toolchain:
```bash
sudo nixos-rebuild switch --flake .#workstation
```
