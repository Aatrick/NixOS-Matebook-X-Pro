{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.winter.vm;
in {
  options.winter.vm = {
    users = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Utilisateurs pour lesquels activer les permissions liées à la virtualisation.";
    };

    # platform = mkOption {
    #   type = types.str;
    #   default = "";
    #   description = "Plateforme CPU (ex: amd ou intel) pour configurer les options IOMMU.";
    # };

    # vfioIds = mkOption {
    #   type = with types; listOf str;
    #   default = [];
    #   description = "Liste des identifiants PCI des périphériques à passer via VFIO.";
    # };
  };

  config = {
    # boot = {
    #   kernelModules = [
    #     "vfio_pci"
    #     "vfio_iommu_type1"
    #     "vfio"
    #   ];
    #   kernelParams = [
    #     "${cfg.platform}_iommu=on"
    #     ("vfio-pci.ids=" + lib.concatStringsSep "," cfg.vfioIds)
    #   ];
    # };

    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd ];
        };
      };
    };

    users.users = builtins.listToAttrs (map (user: {
      name = user;
      value.extraGroups = [ "kvm" "libvirtd" ];
    }) cfg.users);

    environment.systemPackages = with pkgs; [
      spice
      spice-gtk
      spice-vdagent
    ];
  };
}
