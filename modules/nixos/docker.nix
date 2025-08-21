{ lib, config, pkgs, ... }:

{
    virtualisation.podman = {
        enable = true;
        # Create the default bridge network for podman
        defaultNetwork.settings.dns_enabled = true;
    };
}
