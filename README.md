# NixOS-Matebook-X-Pro

To install this NixOS configuration on a fresh machine, you must manually align the hardware state of the new install with the declarative configuration in this repository.

## Install Git and Clone the Repository

On your fresh NixOS install, you need git. If it isn't installed, drop into a shell with it:

```bash
nix-shell -p git
```

The configuration expects to be located at /home/<username>/config for the auto-update scripts to work correctly later.

```bash
git clone <URL_TO_YOUR_REPO> /home/aatricks/config
cd /home/aatricks/config
```

## Update Hardware Configuration

The hardware-configuration.nix files in the repo contain filesystem UUIDs specific to the machines they were pulled from (e.g., mach-w19c or homelab). If you deploy these blindly, your system will fail to boot because it won't find the specified disk partitions.

```bash
cp /etc/nixos/hardware-configuration.nix ./hosts/mach-w19c/hardware-configuration.nix
```

If you are deploying to a new host entirely, create a new directory in hosts/ and define a new entry in flake.nix.

## Deploy the Flake

Apply the configuration using nixos-rebuild. You must specify the hostname defined in flake.nix (either mach-w19c or homelab).

```bash
# Replace 'mach-w19c' with 'homelab' or another host if appropriate
sudo nixos-rebuild switch --flake .#mach-w19c --impure
```
