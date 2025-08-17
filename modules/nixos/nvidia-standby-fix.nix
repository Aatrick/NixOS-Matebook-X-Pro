{ pkgs, lib, config, ... }:

{
  options.winter.nvidia.standby.enable = lib.mkOption {
    description = "Enable Standby fix";
    type = lib.types.bool;
    default = false;
  };

  options.winter.nvidia.standby.old-gpu = lib.mkOption {
    description = "if use gpu before 16 series";
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf config.winter.nvidia.standby.enable
  (
    lib.mkMerge [
      (
        lib.mkIf config.winter.nvidia.standby.old-gpu {
          hardware.nvidia.powerManagement.enable = true;
          boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
        }
      )
      {
        boot.kernelParams = [
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
          "NVreg_TemporaryFilePath=/var/tmp"
        ];

        systemd = {
          services."gnome-suspend" = {
            description = "suspend gnome shell";
            before = [
              "systemd-suspend.service"
              "systemd-hibernate.service"
              "nvidia-suspend.service"
              "nvidia-hibernate.service"
            ];
            wantedBy = [
              "systemd-suspend.service"
              "systemd-hibernate.service"
            ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = ''${pkgs.procps}/bin/pkill -f -STOP ${pkgs.gnome-shell}/bin/gnome-shell'';
            };
          };
          services."gnome-resume" = {
            description = "resume gnome shell";
            after = [
              "systemd-suspend.service"
              "systemd-hibernate.service"
              "nvidia-resume.service"
            ];
            wantedBy = [
              "systemd-suspend.service"
              "systemd-hibernate.service"
            ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = ''${pkgs.procps}/bin/pkill -f -CONT ${pkgs.gnome-shell}/bin/gnome-shell'';
            };
          };
        };
      }
    ]
  );
}
