{
  lib,
  config,
  ...
}: {
  options.winter.security.hardening = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable extra security hardening";
  };

  config = lib.mkMerge [
    {
      security.rtkit.enable = lib.mkDefault true;
      services.gnome.gnome-keyring.enable = lib.mkDefault true;
      security.pam.services.login.enableGnomeKeyring = lib.mkDefault true;
    }
    (lib.mkIf config.winter.security.hardening {
      security.apparmor.enable = true;
      security.auditd.enable = true;
      security.audit.enable = false;
      # security.audit.backlogLimit = 8192;
      # security.audit.rules = [
      #   "-a always,exit -F arch=b64 -S execve"
      #   "-a always,exit -F arch=b32 -S execve"
      # ];
      security.sudo.execWheelOnly = true;

      services.resolved.dnssec = "true";

      # Kernel hardening
      boot.kernelParams = ["page_poison=1" "slub_debug=P" "page_alloc.shuffle=1"];
    })
  ];
}
