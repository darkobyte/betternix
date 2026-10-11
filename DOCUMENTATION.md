# 📖 PULSAR Architecture & Systems Engineering Guide

This document details the architectural layout, modular composition principles, configuration lifecycles, and operational workflows for the **PULSAR** NixOS framework.

---

## 1. Architectural Philosophy

PULSAR is built upon three non-negotiable core invariants:
1. **Single Responsibility per Module:** Each `.nix` file addresses exactly one application, daemon, subsystem, or hardware concern.
2. **Deterministic Hermeticism:** System profiles are constructed via pure flakes (`flake.nix`), importing only explicit combinations of isolated feature modules.
3. **Strict Secret Hygiene:** No personally identifying records (user names, email addresses, host names) exist in version-controlled Nix expressions.

---

## 2. Directory & Module Anatomy

```
nixos-config/
├── .env.json.example        # Sanitized template for environment configuration
├── .gitignore               # Ignores .env.json and evaluation artifacts (result)
├── flake.nix                # Top-level flake declarations & profile factory
├── pulsar.sh                # Centered Interactive TUI management utility
├── README.md                # Project showcase and quickstart documentation
├── DOCUMENTATION.md         # Exhaustive engineering specification (this file)
├── assets/
│   └── wallpapers/
│       └── default.png      # Default system backdrop referenced by theme.nix
├── hosts/                   # Machine targets and hardware specifications
│   ├── workstation/
│   ├── gaming/
│   ├── dev/
│   ├── laptop/
│   └── server/
├── modules/                 # Modular system capabilities
│   ├── core/                # Base OS definitions (networking, audio, users, etc.)
│   ├── desktop/             # Mango WM, Noctiluca bar, displays, and fonts
│   ├── apps/                # Standalone GUI applications
│   ├── gaming/              # Steam, Wine, Proton compatibility stack
│   ├── dev/                 # Virtualization (Docker) and compiler toolchains
│   └── hardware/            # Power management and Bluetooth connectivity
└── home/
    └── user.nix             # Home Manager profile (Zsh, Starship, dotfiles)
```

---

## 3. How the Module Import System Works

Every profile in `hosts/<profile>/default.nix` composes imports from the `modules/` hierarchy:

```nix
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/default.nix
    ../../modules/desktop/default.nix
    ../../modules/apps/firefox.nix
    # ... additional modular features
  ];
}
```

1. **Top-Level Orchestration (`flake.nix`):**
   * Dynamically loads `.env.json`.
   * Invokes `mkHost` which instantiates `nixpkgs.lib.nixosSystem`.
   * Injects `env` and `inputs` into `specialArgs` and `home-manager.extraSpecialArgs`.
2. **Core Injection (`modules/core/secrets.nix`):**
   * Exposes `_module.args.env` to all nested NixOS modules, ensuring that any module in the dependency graph can access `env.username`, `env.hostname`, etc.
3. **Profile Isolation:**
   * Host profiles import only their permitted feature set according to the target workload matrix.

---

## 4. Adding New Components Step-by-Step

### A. Adding a New Standalone Application
1. Create a new file under `modules/apps/<app-name>.nix`:
   ```nix
   { pkgs, ... }:
   {
     environment.systemPackages = with pkgs; [
       <app-name>
     ];
   }
   ```
2. Import the file in the designated profile(s) under `hosts/<target>/default.nix`.

### B. Adding a New Host Target
1. Create a new directory under `hosts/<new-host>/`.
2. Generate or place the hardware configuration:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/<new-host>/hardware-configuration.nix
   ```
3. Create `hosts/<new-host>/default.nix` importing `./hardware-configuration.nix`, `../../modules/core/default.nix`, and the desired feature modules.
4. Register the new target in `flake.nix`:
   ```nix
   nixosConfigurations.<new-host> = mkHost ./hosts/<new-host>;
   ```

### C. Configuring Custom Dotfiles in `home/user.nix`
User configuration is managed natively via Home Manager. To attach dotfiles:
1. Open `home/user.nix`.
2. Use the `xdg.configFile` API for declarative configuration:
   ```nix
   xdg.configFile."mytool/config.toml".text = ''
     theme = "dark"
     enable_logging = true
   '';
   ```
   Or source external files:
   ```nix
   xdg.configFile."mytool/config.toml".source = ./dotfiles/mytool.toml;
   ```

---

## 5. Build Verification & Safety Operations

Before switching a running system, always perform local dry-run tests.

### Using `pulsar.sh`
Run:
```bash
./pulsar.sh
```
Select **`[2] Test & Verify Build`**. This executes:
1. Flake syntax checks (`nix flake check --no-build`).
2. Derivation tree evaluation (`nix eval .#nixosConfigurations.<profile>.config.system.build.toplevel.drvPath`).
3. Dry-run build testing (`nix build .#nixosConfigurations.<profile>.config.system.build.toplevel --dry-run`).

### CLI Commands
```bash
# 1. Check flake metadata
nix flake check --no-build

# 2. Evaluate system derivation
nix eval .#nixosConfigurations.workstation.config.system.build.toplevel.drvPath

# 3. Dry-run test build
nix build .#nixosConfigurations.workstation.config.system.build.toplevel --dry-run
```

---

## 6. Troubleshooting Common Issues

### 1. `error: attribute '<username>' missing`
* **Cause:** `.env.json` is missing or missing required keys (`username`, `hostname`).
* **Fix:** Copy `.env.json.example` to `.env.json` and ensure valid JSON formatting.

### 2. `error: path '...' is not in the Nix store` or `untracked files in Git`
* **Cause:** Nix Flakes only evaluate files that are tracked in the Git staging area or index.
* **Fix:** Stage the new files with `git add <file>` before evaluating.

### 3. Audio or PipeWire Conflict
* **Cause:** Multiple audio servers enabled simultaneously.
* **Fix:** PULSAR standardizes on PipeWire. Ensure `hardware.pulseaudio.enable` remains `false` across all modules.
