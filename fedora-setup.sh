#!/usr/bin/env bash
set -euo pipefail

# -------------------------------
# Fedora Post-Install Setup Script
# Modular + Idempotent Refactor
# -------------------------------

LOG() { echo -e "\033[1;34m[*]\033[0m $*"; }
WARN() { echo -e "\033[1;33m[!]\033[0m $*"; }
ERR() { echo -e "\033[1;31m[✗]\033[0m $*"; }

# --- Package Installation ---
install_packages() {
  LOG "Installing baseline packages..."

  sudo dnf install -y --skip-broken --allowerasing --skip-unavailable \
    gnome-text-editor \
    gnome-calculator \
    nautilus \
    fastfetch \
    htop \
    gnome-tweaks \
    papirus-icon-theme \
  fish \
  podman \
  podman-compose \
  slirp4netns \
  fuse-overlayfs
    
  flatpak install flathub dev.vencord.Vesktop \
    com.brave.Browser \
    com.mattjakeman.ExtensionManager \
    com.valvesoftware.Steam \
    com.valvesoftware.Steam.CompatibilityTool.Proton-GE \
    ca.desrt.dconf-editor  \
    page.tesk.Refine \
    io.github.Foldex.AdwSteamGtk \
    org.zealdocs.Zeal \
    com.spotify.Client \
    com.raggesilver.BlackBox \
    org.gnome.Extensions -y
  
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
  # dnf check-update returns 100 when updates are available, which would exit under set -e
  if sudo dnf -q check-update; then
    LOG "No package updates available."
  else
    LOG "Package updates are available; continuing without upgrading."
  fi
  sudo dnf install -y code-insiders

}


# --- GNOME Extensions ---
install_extensions() {
  echo "[*] Installing GNOME extensions..."

# Install popular extensions from Fedora repos
sudo dnf install -y \
  gnome-shell-extension-appindicator
# dash-to-dock
# caffeine
# blur-my-shell
# user-themes
# weather-oclock
# quick-settings-audio-panel
# light-style

echo "[*] GNOME extensions installed and enabled."
}


# --- GNOME Settings ---
apply_gnome_settings() {
  LOG "Applying GNOME settings..."

  if [[ -f ./gnome-settings.dconf ]]; then
    LOG "Restoring GNOME settings from gnome-settings.dconf"
  if [[ $EUID -eq 0 ]]; then
      # Running under sudo/root: try to apply settings to the invoking user's session
      if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
        local TUSER TU_ID RUNDIR
        TUSER="${SUDO_USER}"
        TU_ID=$(id -u "$TUSER")
        RUNDIR="/run/user/${TU_ID}"

        if [[ -S "${RUNDIR}/bus" ]]; then
          LOG "Applying GNOME settings for user ${TUSER} via DBus session at ${RUNDIR}/bus"
          # Filter to only /org/gnome/ keys to avoid non-writable system keys
          if ! awk 'BEGIN{in=0} /^\[/ {in = ($0 ~ /^\[org\/gnome\//)} {if (in || !/^\[/) print}' ./gnome-settings.dconf \
            | sudo -u "$TUSER" env XDG_RUNTIME_DIR="$RUNDIR" DBUS_SESSION_BUS_ADDRESS="unix:path=${RUNDIR}/bus" dconf load /; then
            WARN "Failed to load GNOME settings for ${TUSER}. Re-run the script without sudo to apply settings."
          fi
        else
          WARN "User DBus session not found at ${RUNDIR}/bus. Skipping GNOME settings restore."
          WARN "Tip: Run this script as the regular user (without sudo) to apply GNOME settings."
        fi
      else
        WARN "No SUDO_USER detected while running as root. Skipping GNOME settings restore."
      fi
    else
      # Filter to only /org/gnome/ keys when applying as a regular user
      if ! awk 'BEGIN{in=0} /^\[/ {in = ($0 ~ /^\[org\/gnome\//)} {if (in || !/^\[/) print}' ./gnome-settings.dconf | dconf load /; then
        WARN "Failed to load GNOME settings. Ensure you're running inside your user session."
      fi
    fi
  else
    WARN "No gnome-settings.dconf found. Skipping GNOME config restore."
    WARN "Run: dconf dump / > gnome-settings.dconf to export your baseline later."
  fi
}

  # --- Fish Shell Setup ---
  set_fish_default_shell() {
    LOG "Ensuring Fish shell is installed and set as default..."

    # Ensure fish is installed (redundant if already installed above, but safe)
    if ! command -v fish >/dev/null 2>&1; then
      LOG "Fish not found; installing..."
      if ! sudo dnf install -y fish; then
        ERR "Failed to install Fish shell. Skipping default shell change."
        return
      fi
    fi

    # Determine fish path
    local FISH_PATH
    FISH_PATH="$(command -v fish || true)"
    if [[ -z "$FISH_PATH" ]]; then
      ERR "Fish binary not found after install. Skipping default shell change."
      return
    fi

    # Determine which user to change shell for
    local TARGET_USER TARGET_SHELL
    if [[ $EUID -eq 0 && -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
      TARGET_USER="${SUDO_USER}"
    else
      TARGET_USER="${USER}"
    fi

    if [[ "${TARGET_USER}" == "root" ]]; then
      WARN "Refusing to change default shell for root. Skipping shell change."
      return
    fi

    # Ensure fish is listed in /etc/shells
    if ! grep -q "^${FISH_PATH}$" /etc/shells; then
      LOG "Adding ${FISH_PATH} to /etc/shells..."
      echo "${FISH_PATH}" | sudo tee -a /etc/shells >/dev/null
    fi

    TARGET_SHELL="$(getent passwd "${TARGET_USER}" | awk -F: '{print $7}')"
    if [[ "${TARGET_SHELL}" == "${FISH_PATH}" ]]; then
      LOG "Fish is already the default shell for ${TARGET_USER}."
      return
    fi

    LOG "Setting default shell to Fish for user ${TARGET_USER}..."
    if chsh -s "${FISH_PATH}" "${TARGET_USER}"; then
      LOG "Default shell changed to Fish for ${TARGET_USER}. Log out and back in to take effect."
    else
      WARN "Could not change default shell automatically. You can run: chsh -s ${FISH_PATH} ${TARGET_USER}"
    fi
  }



# --- Laptop Specific Setup ---
setup_laptop() {
  # Enable RPM Fusion repos if missing
    if ! rpm -qa | grep -q rpmfusion-free-release; then
      LOG "Enabling RPM Fusion repos..."
      sudo dnf install -y \
        "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    fi

    # Check for NVIDIA hardware before installing drivers
    if lspci | grep -qi nvidia; then
      LOG "NVIDIA GPU detected. Installing drivers..."
      sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

      LOG "Installing NVIDIA Container Toolkit for Podman (CUDA support)..."
      sudo dnf install -y nvidia-container-toolkit

      # Generate CDI spec so Podman can resolve nvidia.com/gpu=* devices
      if command -v nvidia-ctk >/dev/null 2>&1; then
        LOG "Generating NVIDIA CDI specification (system-wide)..."
        sudo mkdir -p /etc/cdi
        if [[ ! -f /etc/cdi/nvidia.yaml ]]; then
          if ! sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml; then
            WARN "Failed to generate system CDI spec at /etc/cdi/nvidia.yaml"
          fi
        else
          LOG "NVIDIA CDI spec already exists at /etc/cdi/nvidia.yaml"
        fi

        # Also generate a user-level CDI spec for rootless Podman (harmless if duplicate)
        mkdir -p "$HOME/.config/cdi"
        if [[ ! -f "$HOME/.config/cdi/nvidia.yaml" ]]; then
          if ! nvidia-ctk cdi generate --output="$HOME/.config/cdi/nvidia.yaml"; then
            WARN "Failed to generate user CDI spec at $HOME/.config/cdi/nvidia.yaml"
          fi
        else
          LOG "User CDI spec already exists at $HOME/.config/cdi/nvidia.yaml"
        fi
      else
        WARN "nvidia-ctk not found; cannot generate CDI spec. Ensure nvidia-container-toolkit installed."
      fi

      # Ensure Podman's OCI hooks include NVIDIA hook directory (system-wide)
  if [[ -d /usr/share/containers/oci/hooks.d ]]; then
        LOG "OCI hooks directory exists at /usr/share/containers/oci/hooks.d"
      fi
      sudo mkdir -p /etc/containers
      if ! grep -q "/usr/share/containers/oci/hooks.d" /etc/containers/containers.conf 2>/dev/null; then
        LOG "Configuring containers.conf to include OCI hooks dir (NVIDIA)"
        sudo tee -a /etc/containers/containers.conf >/dev/null <<'EOF'

# Added by fedora-setup.sh for NVIDIA CUDA containers via Podman
[engine]
hooks_dir=["/etc/containers/oci/hooks.d","/usr/share/containers/oci/hooks.d"]
EOF
      else
        LOG "containers.conf already includes OCI hooks directory."
      fi

      # Rootless config for the current user (optional but helpful)
      mkdir -p "$HOME/.config/containers"
      if ! grep -q "hooks_dir" "$HOME/.config/containers/containers.conf" 2>/dev/null; then
        LOG "Adding OCI hooks dir to user containers.conf"
        tee -a "$HOME/.config/containers/containers.conf" >/dev/null <<'EOF'
[engine]
hooks_dir=["/etc/containers/oci/hooks.d","/usr/share/containers/oci/hooks.d"]
EOF
      fi

      LOG "Podman + CUDA support prerequisites installed."
  WARN "To test GPU in Podman after reboot (CDI):"
  WARN "  podman run --rm --device nvidia.com/gpu=all --security-opt=label=disable docker.io/nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi"
  WARN "If CDI is unavailable, you can fallback to legacy hooks:"
  WARN "  podman run --rm --env NVIDIA_VISIBLE_DEVICES=all --security-opt=label=disable docker.io/nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi"
      WARN "A reboot is required for NVIDIA driver to load."
    else
      LOG "No NVIDIA GPU detected. Skipping NVIDIA drivers."
    fi
    
  LOG "Checking if this is a laptop..."
  if [[ $(hostnamectl chassis) == "laptop" ]]; then
    LOG "Laptop detected."

    LOG "Installing TLP for power management..."
    sudo dnf install -y tlp tlp-rdw
    sudo systemctl enable tlp

    # Write TLP config
    sudo tee /etc/tlp.conf > /dev/null <<'EOF'
# TLP custom config
CPU_DRIVER_OPMODE_ON_AC="passive"
CPU_DRIVER_OPMODE_ON_BAT="passive"
CPU_SCALING_GOVERNOR_ON_AC="ondemand"
CPU_SCALING_GOVERNOR_ON_BAT="conservative"
CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance"
CPU_ENERGY_PERF_POLICY_ON_BAT="power"
PLATFORM_PROFILE_ON_AC="performance"
PLATFORM_PROFILE_ON_BAT="low-power"
WIFI_PWR_ON_AC="on"
WIFI_PWR_ON_BAT="on"
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0
CPU_HWP_DYN_BOOST_ON_AC=1
CPU_HWP_DYN_BOOST_ON_BAT=0
PCIE_ASPM_ON_BAT="powersupersave"
USB_AUTOSUSPEND=1
RUNTIME_PM_ON_AC="auto"
RUNTIME_PM_ON_BAT="auto"
RESTORE_DEVICE_STATE_ON_STARTUP=1
START_CHARGE_THRESH_BAT0=65
STOP_CHARGE_THRESH_BAT0=80
TLP_DEFAULT_MODE="BAT"
EOF

    # Ask about undervolt
    read -rp "Apply undervolt settings? (y/N): " REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      LOG "Installing undervolt tool..."
      sudo dnf install -y python3-pip
      sudo pip3 install --upgrade undervolt

      LOG "Creating systemd service for undervolt..."
      sudo tee /etc/systemd/system/undervolt.service > /dev/null <<'EOT'
[Unit]
Description=Apply undervolt settings on boot
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/undervolt --core -95 --uncore -95 --gpu -75 --analogio -20 --temp-bat 50 --temp-ac 70
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOT

      sudo systemctl enable --now undervolt.service
      LOG "Undervolt settings applied and enabled."
    fi
  else
    LOG "Not a laptop. Skipping laptop setup."
  fi

  # If this is a laptop with NVIDIA, set up hybrid graphics with EnvyControl
  if [[ $(hostnamectl chassis) == "laptop" ]] && lspci | grep -qi nvidia; then
    LOG "Configuring hybrid graphics for NVIDIA laptop (EnvyControl)..."

    # Ensure switcheroo-control is installed and enabled (required for per-app GPU switching in GNOME)
    sudo dnf install -y switcheroo-control || true
    sudo systemctl enable --now switcheroo-control || true

    # Install EnvyControl if missing (try DNF, fallback to pip3)
    if ! command -v envycontrol >/dev/null 2>&1; then
      LOG "Installing EnvyControl..."
      if sudo dnf install -y envycontrol; then
        LOG "EnvyControl installed via DNF."
      else
        LOG "EnvyControl not available in DNF; installing via pip3..."
        sudo dnf install -y python3-pip || true
        if sudo pip3 install --upgrade envycontrol; then
          LOG "EnvyControl installed via pip3."
        else
          ERR "Failed to install EnvyControl. Skipping hybrid graphics setup."
          return
        fi
      fi
    fi

    # Detect display manager (default to gdm on Fedora)
    DM="gdm"
    if systemctl is-enabled sddm >/dev/null 2>&1; then DM="sddm"; fi
    if systemctl is-enabled lightdm >/dev/null 2>&1; then DM="lightdm"; fi

    LOG "Setting EnvyControl to hybrid mode (DM=${DM})..."
    if sudo envycontrol -s hybrid --dm "${DM}"; then
      LOG "Hybrid graphics configured. A reboot is required for changes to take effect."
      WARN "After reboot, you can verify offloading with:"
      WARN "  env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo -B | grep 'OpenGL renderer'"
      WARN "GNOME per-app GPU selection appears when switcheroo-control is active."
    else
      WARN "EnvyControl failed to set hybrid mode. You can try manually: envycontrol -s hybrid --dm ${DM}"
    fi
  fi
}

# -------------------------------
# Main
# -------------------------------
install_packages
install_extensions
apply_gnome_settings
set_fish_default_shell
setup_laptop

LOG "Setup complete!"
LOG "Please log out and back in. If NVIDIA drivers were installed, reboot."
