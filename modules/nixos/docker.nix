{ lib, config, pkgs, ... }:

{
    virtualisation.podman = {
        enable = true;
        # Create the default bridge network for podman
        defaultNetwork.settings.dns_enabled = true;
    };
    environment.systemPackages = with pkgs; [
        podman-compose
        nvidia-container-toolkit
    ];
    virtualisation.docker.enableNvidia = true;
    #sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
    #find /nix/store -name nvidia-cdi-hook
    #sudo ln -s /nix/store/cqdvc05s2g8cq6y1v69qyz52ixi8a7hv-nvidia-container-toolkit-1.17.8-tools/bin/nvidia-cdi-hook /usr/bin/nvidia-cdi-hook
}
