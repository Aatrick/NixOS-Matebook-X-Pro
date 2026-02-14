{
  pkgs,
  pkgs-unstable,
  osConfig,
  ...
}:
{
  imports = [
    ../../modules/home-manager/profiles/common.nix
    #../../modules/home-manager/office.nix
    #../../modules/home-manager/vm-manager.nix
    ../../modules/home-manager/android.nix
    ../../modules/home-manager/zed.nix
  ];

  winter = {
    update = {
      flake_path = "/home/aatricks/config";
      flake_config = "mach-w19c";
    };
  };

  home.username = "aatricks";
  home.homeDirectory = "/home/aatricks";
  # home.enableNixpkgsRelease = false;
  home.keyboard = {
    layout = "us";
    variant = "us";
  };

  home.packages = with pkgs; [
    discord
    krita
  ];

  home.file.".config/monitors.xml".text = ''
    <monitors version="2">
      <configuration>
        <layoutmode>logical</layoutmode>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>eDP-1</connector>
              <vendor>JDI</vendor>
              <product>0x422a</product>
              <serial>0x00000000</serial>
            </monitorspec>
            <mode>
              <width>1680</width>
              <height>1050</height>
              <rate>59.954</rate>
            </mode>
          </monitor>
        </logicalmonitor>
      </configuration>
    </monitors>
  '';
}
