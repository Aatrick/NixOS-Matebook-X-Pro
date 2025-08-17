{ lib, pkgs, config, ... }:

let
  cfg = config.winter.wooting;
in {
  options = {
    winter.wooting.enable = lib.mkEnableOption "Enable udev rules for Wooting devices";
  };

  config = lib.mkIf cfg.enable {
    # Install a dedicated udev rules file as 70-wooting.rules
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "wooting-udev-rules";
        destination = "/lib/udev/rules.d/70-wooting.rules";
        text = ''
          # Wooting One Legacy
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"
          SUBSYSTEM=="usb",    ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

          # Wooting One update mode
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

          # Wooting Two Legacy
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"
          SUBSYSTEM=="usb",    ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

          # Wooting Two update mode
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

          # Generic Wooting devices
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"
          SUBSYSTEM=="usb",    ATTRS{idVendor}=="31e3", TAG+="uaccess"
        '';
      })
    ];
  };
}
