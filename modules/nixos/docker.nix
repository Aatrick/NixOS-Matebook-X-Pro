{ pkgs, config, ... }:
{
  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Alias docker=podman
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enable Nvidia Container Toolkit (Modern CDI method)
  hardware.nvidia-container-toolkit.enable = true;

  # Useful tools
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
