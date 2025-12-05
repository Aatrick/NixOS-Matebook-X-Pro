{ lib, ... }:
with lib;
{
  options.winter.hardware.gpu.vendor = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "GPU constructor (amdgpu, nvidia, intel)";
  };

  options.winter.hardware.gpu.enable-acceleration = mkOption {
    type = types.bool;
    default = false;
    description = "enable gpu acceleration (cuda, rocm)";
  };

  options.winter.hardware.gpu.acceleration = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "Acceleration (cuda, rocm)";
  };

  options.winter.games.lsfg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Losseless Scaling (required Lossless scaling app on Steam)";
    };
    steam_library_for_lossless_scaling = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to lossless scaling DLL";
    };
  };
}
