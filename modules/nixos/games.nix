{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: let
  lsfg-vk = pkgs.callPackage ../../pkgs/lsfg-vk.nix {};
  lsfg-vk-ui = pkgs.callPackage ../../pkgs/lsfg-vk-ui.nix {};
in {
  config = {
    programs = {
      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
        # env = {
        #   TZ = ":/etc/localtime";
        #   XKB_DEFAULT_LAYOUT="fr";
        #   XKB_DEFAULT_VARIANT="latin9";
        #   XKB_DEFAULT_OPTIONS="grp:alt_shift_toggle";
        # };
      };
      gamemode.enable = true;
      steam = {
        enable = true;
        gamescopeSession = {
          enable = true;
        };
        extest.enable = true;
        remotePlay.openFirewall = false;
        dedicatedServer.openFirewall = false;
        localNetworkGameTransfers.openFirewall = true;
        extraPackages =
          []
          ++ lib.optional config.winter.games.lsfg.enable lsfg-vk;
        extraCompatPackages = [
          pkgs-unstable.proton-ge-bin
        ];
        package = pkgs.steam.override {
          extraEnv =
            {
              TZ = ":/etc/localtime";
              MANGOHUD = true;
            }
            // (
              if config.winter.games.lsfg.enable == true
              then {
                VK_LAYER_PATH = "${lsfg-vk}/share/vulkan/explicit_layer.d";
                ENABLE_LFSG = 1;
                LSFG_LEGACY = 1;
                LFSG_MULTIPLIER = 2;
              }
              else {}
            )
            // (
              if
                config.winter.games.lsfg.enable
                == true
                && config.winter.games.lsfg.steam_library_for_lossless_scaling != null
              then {
                LSFG_DLL_PATH = "${config.winter.games.lsfg.steam_library_for_lossless_scaling}/steamapps/common/Lossless Scaling/Lossless.dll";
              }
              else {}
            );
        };
      };
    };
    environment = {
      sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        MANGOHUD_CONFIG = "control=mangohud,gpu_list=0,hud_no_margin,legacy_layout=false,horizontal,round_corners=0,background_alpha=0,background_color=000000,font_size=24,text_color=FFFFFF,position=top-center,toggle_hud=Shift_R+F12,no_display,table_columns=1,gpu_text=GPU,gpu_stats,gpu_temp,gpu_power,gpu_color=2E9762,cpu_text=CPU,cpu_stats,cpu_temp,cpu_power,cpu_color=2E97CB,vram,vram_color=AD64C1,ram,ram_color=C26693,battery,battery_color=00FF00,fps,gpu_name,wine,wine_color=EB5B5B,fps_limit_method=late,toggle_fps_limit=Shift_R+F1,fps_limit=0\\,165\\,60\\,30,time";
      };
    };
    environment.systemPackages = with pkgs; [
      mangohud
      adwsteamgtk
    ];
    hardware = {
      graphics = {
        enable = true;
        package = pkgs.mesa;
        package32 = pkgs.pkgsi686Linux.mesa;
      };
    };

    nixpkgs.overlays = [
      (self: super: {
        linuxPackages =
          super.linuxPackages
          // {
            kernel = super.linuxPackages.kernel.override {
              structuredExtraConfig = with lib.kernel; {
                HZ_1000 = yes;
                HZ = 1000;
                PREEMPT_FULL = yes;
                IOSCHED_BFQ = yes;
                DEFAULT_BFQ = yes;
                DEFAULT_IOSCHED = "bfq";
                V4L2_LOOPBACK = module;
                HID = yes;
              };
            };
          };
      })
    ];

    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/scheduler}="bfq"
    '';

    boot.kernel.sysctl = {
      "kernel.split_lock_mitigate" = 0;
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_bytes" = 268435456;
      "vm.max_map_count" = 16777216;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_writeback_centisecs" = 1500;
      "kernel.nmi_watchdog" = 0;
      "kernel.unprivileged_userns_clone" = 1;
      "kernel.printk" = "3 3 3 3";
      "kernel.kptr_restrict" = 2;
      "kernel.kexec_load_disabled" = 1;
    };
  };
}
