{
  lib,
  pkgs,
  config,
  ...
}: {
  services.pulseaudio.enable = false;

  # Enable Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Use WirePlumber
    wireplumber.enable = true;

    # Optimized PipeWire properties for stability and latency
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [44100 48000 88200 96000];
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };

    # Bluetooth quality and codec improvements via WirePlumber
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = ["a2dp_sink" "a2dp_source" "headset_head_unit" "headset_audio_gateway"];
        "bluez5.codecs" = ["ldac" "aptx_hd" "aptx" "aac" "sbc_xq" "sbc"];
      };
    };
  };
}
