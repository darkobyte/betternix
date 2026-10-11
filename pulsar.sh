#!/usr/bin/env bash
# ==============================================================================
# PULSAR - Systemic Modular NixOS Infrastructure & Deployment Framework
# Interactive Terminal UI Management Script
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ANSI Colors & Formatting
BOLD="\033[1m"
DIM="\033[2m"
RED="\033[38;5;196m"
GREEN="\033[38;5;46m"
YELLOW="\033[38;5;226m"
BLUE="\033[38;5;39m"
PURPLE="\033[38;5;135m"
CYAN="\033[38;5;51m"
WHITE="\033[38;5;231m"
GRAY="\033[38;5;244m"
RESET="\033[0m"

# Terminal Geometry & Centering Helpers
get_term_size() {
    TERM_COLS=$(tput cols 2>/dev/null || echo 80)
    TERM_ROWS=$(tput lines 2>/dev/null || echo 24)
}

print_center() {
    local text="$1"
    local raw_len
    # Strip ANSI color escape codes for calculating real width
    raw_len=$(echo -e "$text" | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' | wc -c)
    local padding=$(( (TERM_COLS - raw_len) / 2 ))
    if [ "$padding" -gt 0 ]; then
        printf "%*s%b\n" "$padding" "" "$text"
    else
        printf "%b\n" "$text"
    fi
}

pause_prompt() {
    echo ""
    print_center "${DIM}Press [Enter] to return to the main menu...${RESET}"
    read -r
}

draw_header() {
    clear
    get_term_size
    echo ""
    print_center "${CYAN}██████╗ ██╗   ██╗██╗     ███████╗ █████╗ ██████╗ ${RESET}"
    print_center "${CYAN}██╔══██╗██║   ██║██║     ██╔════╝██╔══██╗██╔══██╗${RESET}"
    print_center "${BLUE}██████╔╝██║   ██║██║     ███████╗███████║██████╔╝${RESET}"
    print_center "${BLUE}██╔═══╝ ██║   ██║██║     ╚════██║██╔══██║██╔══██╗${RESET}"
    print_center "${PURPLE}██║     ╚██████╔╝███████╗███████║██║  ██║██║  ██║${RESET}"
    print_center "${PURPLE}╚═╝      ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝${RESET}"
    echo ""
    print_center "${BOLD}${WHITE}Systemic Modular NixOS Infrastructure & Deployment Framework${RESET}"
    print_center "${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

ensure_env_exists() {
    if [ ! -f "$SCRIPT_DIR/.env.json" ]; then
        echo -e "${YELLOW}[!] Notice:${RESET} .env.json was not found."
        if [ -f "$SCRIPT_DIR/.env.json.example" ]; then
            cp "$SCRIPT_DIR/.env.json.example" "$SCRIPT_DIR/.env.json"
            echo -e "${GREEN}[✓] Initialized .env.json from template.${RESET}"
        else
            cat <<EOF > "$SCRIPT_DIR/.env.json"
{
  "username": "pulsar",
  "fullName": "Pulsar Administrator",
  "email": "pulsar@example.com",
  "hostname": "pulsar-workstation",
  "timezone": "UTC",
  "locale": "en_US.UTF-8"
}
EOF
            echo -e "${GREEN}[✓] Generated default .env.json file.${RESET}"
        fi
    fi
}

select_profile() {
    local prompt_text="$1"
    echo ""
    print_center "${BOLD}${WHITE}${prompt_text}${RESET}"
    echo ""
    local profiles=("workstation" "gaming" "dev" "laptop" "server")
    for i in "${!profiles[@]}"; do
        print_center "${BLUE}[$((i+1))]${RESET} ${WHITE}${profiles[$i]}${RESET}"
    done
    echo ""
    while true; do
        read -p "       Select target host [1-${#profiles[@]}]: " choice
        if [[ "$choice" =~ ^[1-5]$ ]]; then
            TARGET_PROFILE="${profiles[$((choice-1))]}"
            break
        else
            echo -e "       ${RED}Invalid selection. Please choose 1-${#profiles[@]}.${RESET}"
        fi
    done
}

configure_env() {
    draw_header
    print_center "${BOLD}${YELLOW}── CONFIGURE ENVIRONMENT & SECRETS ──${RESET}"
    echo ""
    ensure_env_exists

    local current_user current_name current_email current_host current_tz current_locale

    current_user=$(grep '"username"' .env.json | sed -E 's/.*: *"([^"]*)".*/\1/' || echo "pulsar")
    current_name=$(grep '"fullName"' .env.json | sed -E 's/.*: *"([^"]*)".*/\1/' || echo "Pulsar Administrator")
    current_email=$(grep '"email"' .env.json | sed -E 's/.*: *"([^"]*)".*/\1/' || echo "pulsar@example.com")
    current_host=$(grep '"hostname"' .env.json | sed -E 's/.*: *"([^"]*)".*/\1/' || echo "pulsar-node")
    current_tz=$(grep '"timezone"' .env.json | sed -E 's/.*: *"([^"]*)".*/\1/' || echo "UTC")
    current_locale=$(grep '"locale"' .env.json | sed -E 's/.*: *"([^"]*)".*/\1/' || echo "en_US.UTF-8")

    echo -e "  Current configuration loaded from ${CYAN}.env.json${RESET}:"
    echo -e "  Press [Enter] to retain current value in [brackets]."
    echo ""

    read -p "  Enter Username       [${current_user}]: " input_user
    read -p "  Enter Full Name      [${current_name}]: " input_name
    read -p "  Enter Email Address  [${current_email}]: " input_email
    read -p "  Enter Hostname       [${current_host}]: " input_host
    read -p "  Enter Timezone       [${current_tz}]: " input_tz
    read -p "  Enter Locale         [${current_locale}]: " input_locale

    local final_user="${input_user:-$current_user}"
    local final_name="${input_name:-$current_name}"
    local final_email="${input_email:-$current_email}"
    local final_host="${input_host:-$current_host}"
    local final_tz="${input_tz:-$current_tz}"
    local final_locale="${input_locale:-$current_locale}"

    cat <<EOF > .env.json
{
  "username": "${final_user}",
  "fullName": "${final_name}",
  "email": "${final_email}",
  "hostname": "${final_host}",
  "timezone": "${final_tz}",
  "locale": "${final_locale}"
}
EOF
    echo ""
    echo -e "  ${GREEN}[✓] .env.json successfully updated!${RESET}"
    pause_prompt
}

verify_build() {
    draw_header
    print_center "${BOLD}${BLUE}── TEST & VERIFY NIXOS BUILD ──${RESET}"
    echo ""
    ensure_env_exists

    select_profile "Choose Host Profile to Verify"

    echo ""
    echo -e "  ${CYAN}[1/3] Step 1: Evaluating Flake Validity & Metadata...${RESET}"
    if nix flake check --no-build; then
        echo -e "  ${GREEN}[✓] Flake check passed!${RESET}"
    else
        echo -e "  ${RED}[✗] Flake evaluation encountered errors.${RESET}"
        pause_prompt
        return 1
    fi

    echo ""
    echo -e "  ${CYAN}[2/3] Step 2: Testing Dry Activation Evaluation...${RESET}"
    if nix eval ".#nixosConfigurations.${TARGET_PROFILE}.config.system.build.toplevel.drvPath"; then
        echo -e "  ${GREEN}[✓] NixOS derivation evaluated cleanly!${RESET}"
    else
        echo -e "  ${RED}[✗] Failed to evaluate NixOS derivation.${RESET}"
        pause_prompt
        return 1
    fi

    echo ""
    echo -e "  ${CYAN}[3/3] Step 3: Performing Test Dry-Build (nix build --dry-run)...${RESET}"
    if nix build ".#nixosConfigurations.${TARGET_PROFILE}.config.system.build.toplevel" --dry-run; then
        echo -e "  ${GREEN}[✓] Target profile (${TARGET_PROFILE}) verified safely!${RESET}"
    else
        echo -e "  ${RED}[✗] Dry-run build failed.${RESET}"
        pause_prompt
        return 1
    fi

    echo ""
    echo -e "  ${BOLD}${GREEN}==> ALL BUILD VERIFICATION CHECKS PASSED FOR '${TARGET_PROFILE}' <==${RESET}"
    pause_prompt
}

full_setup() {
    draw_header
    print_center "${BOLD}${GREEN}── START FULL SYSTEM SETUP ──${RESET}"
    echo ""
    print_center "1. Guided .env.json Setup ➔ 2. Verification Check ➔ 3. Deployment Switch"
    echo ""

    ensure_env_exists
    echo -e "  Would you like to review or customize your environment variables now? (y/N)"
    read -p "  Selection: " review_env
    if [[ "$review_env" =~ ^[Yy]$ ]]; then
        configure_env
        draw_header
        print_center "${BOLD}${GREEN}── START FULL SYSTEM SETUP (CONTINUED) ──${RESET}"
        echo ""
    fi

    select_profile "Select Target Host Profile for Deployment"

    echo ""
    echo -e "  ${CYAN}[1/3] Running pre-deployment build verification...${RESET}"
    if ! nix flake check --no-build; then
        echo -e "  ${RED}[✗] Flake validation failed! Aborting deployment to protect system.${RESET}"
        pause_prompt
        return 1
    fi

    echo ""
    echo -e "  ${CYAN}[2/3] Building target profile (${TARGET_PROFILE})...${RESET}"
    if ! nix build ".#nixosConfigurations.${TARGET_PROFILE}.config.system.build.toplevel" --dry-run; then
        echo -e "  ${RED}[✗] Dry-run build failed! Aborting to prevent an unbootable state.${RESET}"
        pause_prompt
        return 1
    fi

    echo ""
    echo -e "  ${CYAN}[3/3] Ready to switch system configuration.${RESET}"
    echo -e "  ${YELLOW}Target profile:${RESET} ${WHITE}${TARGET_PROFILE}${RESET}"
    read -p "  Apply and switch now with sudo nixos-rebuild switch? (y/N): " confirm_switch

    if [[ "$confirm_switch" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "  ${BLUE}[+] Applying configuration...${RESET}"
        sudo nixos-rebuild switch --flake ".#${TARGET_PROFILE}"
        echo ""
        echo -e "  ${GREEN}[✓] PULSAR System Setup Successfully Applied!${RESET}"
    else
        echo -e "  ${YELLOW}[-] Deployment switch skipped.${RESET}"
    fi

    pause_prompt
}

reload_config() {
    draw_header
    print_center "${BOLD}${PURPLE}── RELOAD CONFIGURATION & SERVICES ──${RESET}"
    echo ""
    ensure_env_exists
    select_profile "Select Profile to Rebuild & Switch"

    echo ""
    echo -e "  ${BLUE}[1/2] Reloading systemd manager configuration...${RESET}"
    sudo systemctl daemon-reload || true
    echo -e "  ${GREEN}[✓] Systemd daemon reloaded.${RESET}"

    echo ""
    echo -e "  ${BLUE}[2/2] Switching NixOS configuration...${RESET}"
    sudo nixos-rebuild switch --flake ".#${TARGET_PROFILE}"
    echo -e "  ${GREEN}[✓] Rebuild and switch completed!${RESET}"

    pause_prompt
}

optimize_store() {
    draw_header
    print_center "${BOLD}${CYAN}── CLEAN & OPTIMIZE NIX STORE ──${RESET}"
    echo ""
    echo -e "  ${YELLOW}[1/2] Collecting garbage and deleting older generations...${RESET}"
    nix-collect-garbage -d
    echo -e "  ${GREEN}[✓] Garbage collection finished.${RESET}"

    echo ""
    echo -e "  ${YELLOW}[2/2] Hard-linking and optimising Nix Store...${RESET}"
    nix-store --optimise
    echo -e "  ${GREEN}[✓] Nix store optimisation completed.${RESET}"

    pause_prompt
}

# Main Interactive Loop
while true; do
    draw_header
    print_center "${BOLD}${WHITE}PULSAR CONTROL PANEL${RESET}"
    echo ""
    print_center "${BLUE}[1]${RESET}  ${WHITE}Start Full System Setup${RESET}          ${GRAY}(Guided .env + verify + switch)${RESET}  "
    print_center "${BLUE}[2]${RESET}  ${WHITE}Test & Verify Build${RESET}              ${GRAY}(nix flake check & test dry-run)${RESET}"
    print_center "${BLUE}[3]${RESET}  ${WHITE}Reload Configuration & Services${RESET}  ${GRAY}(systemctl daemon-reload + switch)${RESET} "
    print_center "${BLUE}[4]${RESET}  ${WHITE}Configure Environment Variables${RESET}  ${GRAY}(Interactively edit .env.json)${RESET}   "
    print_center "${BLUE}[5]${RESET}  ${WHITE}Clean & Optimize Nix Store${RESET}       ${GRAY}(nix-collect-garbage & optimise)${RESET} "
    print_center "${RED}[6]${RESET}  ${WHITE}Exit${RESET}                             ${GRAY}(Close PULSAR Control Panel)${RESET}     "
    echo ""
    print_center "${GRAY}─────────────────────────────────────────────────────────────${RESET}"
    echo ""

    read -p "       Select an option [1-6]: " opt
    case "$opt" in
        1) full_setup ;;
        2) verify_build ;;
        3) reload_config ;;
        4) configure_env ;;
        5) optimize_store ;;
        6)
            echo ""
            print_center "${GREEN}Thank you for using PULSAR. Safe travels through the stars!${RESET}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "       ${RED}Invalid option. Please choose between 1 and 6.${RESET}"
            sleep 1
            ;;
    esac
done
