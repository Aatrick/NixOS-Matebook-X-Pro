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

  sudo dnf install -y --skip-broken --allowerasing \
    wine \
    gnome-text-editor \
    gnome-calculator \
    file-roller \
    nautilus \
    fastfetch \
    htop \
    gnome-tweaks \
    dconf-editor \
    gnome-shell-extension-manager \
    steam \
    papirus-icon-theme
}


# --- GNOME Extensions ---
install_extensions() {
  LOG "Installing GNOME extensions..."

  # Install gnome-extensions-cli if not present
  if ! command -v gnome-extensions-cli &>/dev/null; then
    LOG "gnome-extensions-cli not found, installing..."
    wget -qO /tmp/gnome-extensions-cli.py https://raw.githubusercontent.com/GNOME/gnome-extensions-cli/main/gnome-extensions-cli.py
    chmod +x /tmp/gnome-extensions-cli.py
    sudo mv /tmp/gnome-extensions-cli.py /usr/local/bin/gnome-extensions-cli
  fi

  EXTENSIONS=(
    dash-to-dock@micxgx.gmail.com
    blur-my-shell@aunetx
    appindicatorsupport@rgcjonas.gmail.com
    light-style@gnome-shell-extensions.gcampax.github.com
    caffeine@patapon.info
    user-theme@gnome-shell-extensions.gcampax.github.com
    places-menu@gnome-shell-extensions.gcampax.github.com
    quick-settings-audio-panel@gnome-shell-extensions.gcampax.github.com
    weatheroclock@malekim.github.io
  )

  for ext in "${EXTENSIONS[@]}"; do
    if ! gnome-extensions list | grep -q "$ext"; then
      LOG "Installing extension: $ext"
      gnome-extensions-cli install "$ext"
    else
      LOG "Extension already installed: $ext"
    fi
  done
}


# --- GNOME Settings ---
apply_gnome_settings() {
  LOG "Applying GNOME settings..."

  if [[ -f ./gnome-settings.dconf ]]; then
    LOG "Restoring GNOME settings from gnome-settings.dconf"
    dconf load / < ./gnome-settings.dconf
  else
    WARN "No gnome-settings.dconf found. Skipping GNOME config restore."
    WARN "Run: dconf dump / > gnome-settings.dconf to export your baseline later."
  fi
}


# --- Laptop Specific Setup ---
setup_laptop() {
  LOG "Checking if this is a laptop..."
  if [[ $(hostnamectl chassis) == "laptop" ]]; then
    LOG "Laptop detected."

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
      WARN "A reboot is required for NVIDIA driver to load."
    else
      LOG "No NVIDIA GPU detected. Skipping NVIDIA drivers."
    fi

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
}

# -------------------------------
# Main
# -------------------------------
install_packages
install_extensions
apply_gnome_settings
setup_laptop

LOG "Setup complete!"
LOG "Please log out and back in. If NVIDIA drivers were installed, reboot."
