sudo pacman -Syu --noconfirm

# Accelerate pacman
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
sudo echo "ILoveCandy" >> /etc/pacman.conf

sudo pacman -S --noconfirm reflector git nano

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Install paru AUR helper
sudo pacman -S --needed --noconfirm base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Install xorg
sudo pacman -S --noconfirm xorg

# Install GNOME
sudo pacman -S --noconfirm gnome-shell gdm gnome-console gnome-control-center gnome-keyring gnome-menus gnome-session gnome-settings-daemon gnome-shell-extensions gnome-text-editor nautilus gnome-weather gnome-tweaks

sudo systemctl enable gdm.service

sudo pacman -S --noconfirm cpupower acpi acpid intel-ucode 

# Install and enable tlp
sudo pacman -S --noconfirm tlp tlp-rdw smartmontools ethtool thermald

sudo tee /etc/tlp.conf << EOF
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

sudo tlp start

sudo systemctl enable tlp
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket
sudo systemctl enable NetworkManager-dispatcher.service

# Undervolt CPU
sudo pacman -S intel-undervolt

sudo tee /etc/intel/intel-undervolt.conf << EOF
# Enable or Disable Triggers (elogind)
# Usage: enable [yes/no]

enable no

# CPU Undervolting
# Usage: undervolt ${index} ${display_name} ${undervolt_value}
# Example: undervolt 2 'CPU Cache' -25.84

undervolt 0 'CPU' -95
undervolt 1 'GPU' -80
undervolt 2 'CPU Cache' -95
undervolt 3 'System Agent' -30
undervolt 4 'Analog I/O' -30

# Power Limits Alteration
# Usage: power ${domain} ${short_power_value} ${long_power_value}
# Power value: ${power}[/${time_window}][:enabled][:disabled]
# Domains: package
# Example: power package 45 35
# Example: power package 45/0.002 35/28
# Example: power package 45/0.002:disabled 35/28:enabled

# Critical Temperature Offset Alteration
# Usage: tjoffset ${temperature_offset}
# Example: tjoffset -20

# Energy Versus Performance Preference Switch
# Usage: hwphint ${mode} ${algorithm} ${load_hint} ${normal_hint}
# Hints: see energy_performance_available_preferences
# Modes: switch, force
# Load algorithm: load:${capture}:${threshold}
# Power algorithm: power[:${domain}:[gt/lt]:${value}[:[and/or]]...]
# Capture: single, multi
# Threshold: CPU usage threshold
# Domain: RAPL power domain, check with `intel-undervolt measure`
# Example: hwphint force load:single:0.8 performance balance_performance
# Example: hwphint switch power:core:gt:8 performance balance_performance
hwphint switch load:single:0.9 balance_power power

# Daemon Update Interval
# Usage: interval ${interval_in_milliseconds}

interval 5000

# Daemon Actions
# Usage: daemon action[:option...]
# Actions: undervolt, power, tjoffset
# Options: once

daemon undervolt:once
daemon power
daemon tjoffset
EOF

sudo systemctl enable intel-undervolt

# Install video drivers
paru -S --noconfirm xf86-video-intel libvdpau-va-gl intel-media-driver sof-firmware nvidia-dkms nvidia-utils nvidia-settings

# Set environment variables safely using tee
sudo tee -a /etc/environment << EOF
LIBVA_DRIVER_NAME=iHD
VDPAU_DRIVER=va_gl
EOF

sudo pacman -S --noconfirm htop

# Create wallpapers directory and download a default wallpaper
mkdir -p ~/Pictures/Wallpapers
curl -o ~/Pictures/Wallpapers/default-wallpaper.jpg https://raw.githubusercontent.com/vinceliuice/WhiteSur-wallpapers/main/4k/Monterey-dark.jpg

# Set the wallpaper
gsettings set org.gnome.desktop.background picture-uri "file:///home/$USER/Pictures/Wallpapers/default-wallpaper.jpg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///home/$USER/Pictures/Wallpapers/default-wallpaper.jpg"

# Install vscode, chrome and other apps
paru -S visual-studio-code-insiders-bin brave-bin vlc envycontrol flatpak fish

chsh -s /usr/bin/fish

flatpak install flathub dev.vencord.Vesktop \
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

# install uv 
curl -LsSf https://astral.sh/uv/install.sh | sh

# Enable the integrated graphics
sudo envycontrol -s integrated

sudo systemctl enable bluetooth

sudo systemctl reboot
