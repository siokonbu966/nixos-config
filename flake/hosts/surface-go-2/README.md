# Surface Go 2

This is a separate, lightweight NixOS profile for the Surface Go 2. It uses
the Surface-patched kernel from `nixos-hardware`, a Sway Wayland session, a
small set of graphical applications, and zram swap. The first kernel build can
take considerably longer than a stock NixOS kernel build.

## Disk layout

The checked-in hardware configuration intentionally uses filesystem labels
instead of another machine's UUIDs. It expects a UEFI EFI System Partition and
an ext4 root partition:

| Mount point | Filesystem | Label |
| --- | --- | --- |
| `/boot` | FAT32 | `NIXOS_BOOT` |
| `/` | ext4 | `nixos` |

If a different partition layout is used, update
`hardware-configuration.nix` to match it before installing. No persistent swap
partition is required; the profile enables zram swap.

## Install

Boot a 64-bit NixOS installer in UEFI mode, prepare and mount the partitions
using the labels above, then install the `surface-go-2` flake target from this
repository. Before rebooting, set the configured user's password from the
installed system root (for this repository's default user):

```sh
nixos-enter --root /mnt -c 'passwd crocus'
```

Secure Boot must be disabled unless a separate Secure Boot setup is added.

The Sway session starts the on-screen keyboard automatically. `Mod4+d` opens
the application launcher and `Mod4+Return` opens a terminal. Firefox is
included as the basic graphical application. Japanese locale, keyboard
layout, fonts, and Mozc input are enabled.

Surface Go 2 camera and LTE support may still have upstream limitations; see
the [NixOS Surface Go 2 hardware page](https://wiki.nixos.org/wiki/Hardware/Microsoft/Surface_Go_2)
and [linux-surface feature matrix](https://github.com/linux-surface/linux-surface/wiki/Supported-Devices-and-Features#feature-matrix).
