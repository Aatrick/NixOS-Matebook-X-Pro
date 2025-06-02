{ pkgs, pkgs-unstable, ... }:

{
  programs = {
    gamescope.enable = true;
    gamemode.enable = true;
    steam = {
      gamescopeSession.enable = true;
      enable = true;
      extest.enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [
        pkgs-unstable.proton-ge-bin
      ];
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
        };
      };
    };
  };
  environment = {
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      MANGOHUD_CONFIG = "control=mangohud,hud_no_margin,legacy_layout=false,horizontal,background_alpha=0.6,round_corners=0,background_alpha=0.2,background_color=000000,font_size=24,text_color=FFFFFF,position=top-center,toggle_hud=Shift_R+F12,no_display,table_columns=1,gpu_text=GPU,gpu_stats,gpu_temp,gpu_power,gpu_color=2E9762,cpu_text=CPU,cpu_stats,cpu_temp,cpu_power,cpu_color=2E97CB,vram,vram_color=AD64C1,vram_color=AD64C1,ram,ram_color=C26693,battery,battery_color=00FF00,fps,gpu_name,wine,wine_color=EB5B5B,fps_limit_method=late,toggle_fps_limit=Shift_L+F1,fps_limit=0,time";
    };
  };
  environment.systemPackages = with pkgs; [
    mangohud
    adwsteamgtk
  ];
}
