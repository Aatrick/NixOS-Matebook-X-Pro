{ pkgs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.framework-16-7040-amd
    ./hardware/fw-laptop-16.nix
    ../modules/bootloader.nix
    ../modules/common.nix
    ../modules/fonts.nix
    ../modules/firefox.nix
    ../modules/users.nix
    ../modules/sound.nix
    ../modules/desktop-gnome.nix
    ../modules/security.nix
    ../modules/vm.nix
    ../modules/zram.nix
    ../modules/games.nix
    ../modules/ollama.nix
    ../modules/update.nix
    ../modules/postgresSQL.nix
    ../modules/zuka_bot.nix
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" "defaults" ];
    fileSystems."/mnt/Games" =
    { device = "/dev/disk/by-uuid/1b35568b-4447-4c80-9880-4b359d4ecb6c";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };
    # environment.systemPackages = with pkgs; [
    #   gnome-randr
    # ];
    services.udev.extraRules = ''
      # Framework Laptop 16 Keyboard Module - ANSI
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"

      # Framework Laptop 16 RGB Macropad
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0013", ATTR{power/wakeup}="disabled"

      # Framework Laptop 16 Numpad Module
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled"

      # Framework Laptop 16 Keyboard Module - ISO
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0018", ATTR{power/wakeup}="disabled"

      # Unplug
      SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="0",RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"

      # Plug
      SUBSYSTEM=="power_supply",ENV{POWER_SUPPLY_ONLINE}=="1",RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"

    '';

    /*
    RUN+="${pkgs.lib.getExe (pkgs.writeShellScriptBin "powersave"
    ''
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
      ${pkgs.su}/bin/su - quentin -c "${pkgs.dbus}/bin/dbus-launch `${pkgs.gnome-randr}/bin/gnome-randr modify 'eDP-1' --mode 2560x1600@60.002`"
    '')}"

    "${pkgs.lib.getExe (pkgs.writeShellScriptBin "performance"
    ''
      ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance
      ${pkgs.su}/bin/su - quentin -c "${pkgs.dbus}/bin/dbus-launch `${pkgs.gnome-randr}/bin/gnome-randr modify 'eDP-1' --mode 2560x1600@165.000`"
    '')}"
    */
}
