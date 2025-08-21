#!/bin/bash

# Fedora Setup Script
# This script is generated from your NixOS configuration.

# --- Package Installation ---
echo "Installing packages..."
sudo dnf install -y \
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

# --- GNOME Extension Installation ---
echo "Installing GNOME extensions..."

# Install gnome-extensions-cli if not present
if ! command -v gnome-extensions-cli &> /dev/null
then
    echo "gnome-extensions-cli not found, installing..."
    wget -O gnome-extensions-cli.py https://raw.githubusercontent.com/GNOME/gnome-extensions-cli/main/gnome-extensions-cli.py
    chmod +x gnome-extensions-cli.py
    sudo mv gnome-extensions-cli.py /usr/local/bin/gnome-extensions-cli
fi

gnome-extensions-cli install dash-to-dock@micxgx.gmail.com
gnome-extensions-cli install blur-my-shell@aunetx
gnome-extensions-cli install appindicatorsupport@rgcjonas.gmail.com
gnome-extensions-cli install light-style@gnome-shell-extensions.gcampax.github.com
gnome-extensions-cli install caffeine@patapon.info
gnome-extensions-cli install user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions-cli install places-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions-cli install quick-settings-audio-panel@gnome-shell-extensions.gcampax.github.com
gnome-extensions-cli install weatheroclock@malekim.github.io


# --- Dconf Settings ---
echo "Applying dconf settings..."

dconf write /org/gnome/shell/disable-user-extensions false
dconf write /org/gnome/shell/enabled-extensions "['blur-my-shell@aunetx', 'dash-to-dock@micxgx.gmail.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'caffeine@patapon.info', 'appindicatorsupport@rgcjonas.gmail.com', 'light-style@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com', 'quick-settings-audio-panel@gnome-shell-extensions.gcampax.github.com', 'weatheroclock@malekim.github.io']"
dconf write /org/gnome/shell/favorite-apps "['vesktop.desktop', 'spotify.desktop', 'brave-browser.desktop', 'com.raggesilver.BlackBox.desktop', 'code.desktop']"
dconf write /org/gnome/nautilus/list-view/use-tree-view true
dconf write /org/gnome/desktop/privacy/old-files-age "uint32 1"
dconf write /org/gnome/desktop/privacy/remove-old-temp-files true
dconf write /org/gnome/desktop/privacy/remove-old-trash-files true
dconf write /org/gnome/desktop/peripherals/touchpad/speed 0.18
dconf write /org/gnome/desktop/interface/accent-color "'teal'"
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus'"
dconf write /org/gnome/desktop/interface/show-battery-percentage true
dconf write /org/gnome/desktop/interface/toolbar-style "'text'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita'"
dconf write /org/gnome/desktop/interface/text-scaling-factor 0.95
dconf write /org/gnome/desktop/app-folders/folder-children "['System', 'Utilities', 'YaST', 'Pardus', 'SysApps']"
dconf write /org/gnome/desktop/app-folders/folders/Utilities/apps "['org.gnome.Connections.desktop', 'org.gnome.Evince.desktop', 'org.gnome.font-viewer.desktop', 'org.gnome.Loupe.desktop', 'org.gnome.seahorse.Application.desktop', 'com.mattjakeman.ExtensionManager.desktop', 'ca.desrt.dconf-editor.desktop', 'org.gnome.tweaks.desktop', 'org.gnome.Calculator.desktop']"
dconf write /org/gnome/desktop/app-folders/folders/SysApps/apps "['org.gnome.Extensions.desktop', 'org.gnome.Settings.desktop', 'org.gnome.FileRoller.desktop', 'cmake-gui.desktop', 'htop.desktop', 'fish.desktop', 'nixos-manual.desktop', 'vlc.desktop', 'io.github.Foldex.AdwSteamGtk.desktop']"
dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,maximize,close'"
dconf write /org/desktop/vm/preferences/button-layout "'appmenu:minimize,maximize,close'"
dconf write /org/gnome/shell/extensions/weather-oclock/weather-after-clock true
dconf write /org/gnome/shell/extensions/dash-to-dock/show-icons-emblems false
dconf write /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button false
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash false
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'FIXED'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink true

# --- Laptop Specific Setup ---
if [[ $(hostnamectl status | grep "Chassis:" | awk '{print $2}') == "laptop" ]]; then
  echo "Laptop detected. Installing NVIDIA drivers and TLP..."

  # Enable RPM Fusion repositories
  sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
  sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

  # Install NVIDIA drivers and TLP
  sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda tlp tlp-rdw

  # Enable TLP
  sudo systemctl enable tlp

  # Configure TLP from power.nix
  sudo tee /etc/tlp.conf > /dev/null <<EOF
# TLP settings based on power.nix
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

  echo "NVIDIA drivers and TLP have been installed."

  # Undervolt prompt
  read -p "This laptop may support undervolting. Do you want to apply undervolt settings? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
      echo "Applying undervolt settings..."
      # Install undervolt tool
      sudo dnf install -y python3-pip
      sudo pip3 install undervolt

      # Apply settings from mach-w19c/configuration.nix
      sudo undervolt --core -95 --uncore -95 --gpu -75 --analogio -20 --temp-bat 50 --temp-ac 70

      # Create systemd service for undervolt to apply on boot
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

      # Enable the service
      sudo systemctl enable --now undervolt.service
      echo "Undervolt settings applied and will be reapplied on boot."
  fi

  echo "A reboot is required for the NVIDIA driver to be loaded."
fi


echo "Setup complete!"
echo "Please log out and log back in for all changes to take effect."
echo "If NVIDIA drivers were installed, please reboot your system."
