# GlouOS - a gaming-focused Arch Linux distribution

GlouOS is an [archiso](https://gitlab.archlinux.org/archlinux/archiso) profile: a
folder of config files that `mkarchiso` turns into a bootable, installable ISO.
It targets **gaming**, with a **light, minimalist, Windows-like KDE Plasma**
desktop and a simple installer that sets up your apps and graphics drivers for
you, so everything is ready the moment you reach the desktop.

> Status: scaffold. Everything here is editable text. Building requires an Arch
> Linux host (see below) - you can't run `mkarchiso` on Windows directly.

---

## Design goals

- **Light mode and minimalist** everywhere: the desktop, the login screen and the
  installer all use a clean light Breeze look.
- **Lightweight**: a slim base. GPU drivers and big launchers are installed
  on-demand during setup, not baked into the ISO, so you only get what you need.
- **Familiar**: a Windows-style desktop, double-click to open, double-click an
  `.exe` to run it.

## What's in the box

| Area | Choice |
|---|---|
| Base | Arch Linux (rolling), deliberately slim |
| Kernel | `linux-zen` (low-latency scheduler) |
| Desktop | KDE Plasma (Wayland), light + Windows-like |
| Settings | "GlouOS Settings": a real Windows-11-style settings app with working panels (network, bluetooth, display, apps, time, gaming, security, updates) |
| Audio | PipeWire (low latency) |
| Graphics | Mesa in the base; vendor driver (AMD/Intel/NVIDIA) chosen in the installer |
| Gaming tools | GameMode, MangoHud, Gamescope, Wine (preinstalled) |
| Apps | Steam, Discord, OBS, Spotify, etc. chosen in the installer's Packages step |
| .exe support | Double-click a Windows `.exe`/`.msi` and it runs through Wine |
| Installer | Calamares, light-themed, GlouOS branding (`archinstall` as fallback) |
| Updates | Detected in the background; one-click GUI updater, no terminal, no reinstall (see [docs/UPDATES.md](docs/UPDATES.md)) |
| Boot splash | Light, branded Plymouth splash (live + installed) |
| Authenticity | ISO + packages signed by the GlouOS key; pacman refuses impostors (see [docs/AUTHENTICITY.md](docs/AUTHENTICITY.md)) |
| Secure Boot | Optional "Secure Boot Setup" wizard (sbctl) for verified boot |

## The installer flow

The graphical installer is a minimalist 5-step wizard:

1. **Installation Settings** - language/location, keyboard, disk/partitioning, user account
2. **Packages** - tick the apps you want (Steam, Discord, OBS, Spotify, ...)
3. **Drivers** - pick your GPU (AMD / Intel / NVIDIA); the right driver is installed now
4. **Installation Process** - it does the work while the slideshow plays
5. **Welcome to GlouOS** - finished

Because Packages and Drivers run during install, the system is fully set up on
first boot. (Steps 2-3 download from the internet, so connect during install.)

## File map

GlouOS's own files live in the **`glouos-base` package** (so they are updatable),
not in the ISO overlay. The archiso `airootfs/` keeps only what cannot be a
package (bootloader, repos, live-only config).

```
profiledef.sh          ISO name, label, boot modes, compression
packages.x86_64        the package list (includes glouos-base)
pacman.conf            repos used during the BUILD (multilib + temp local repo)
build.sh               builds glouos-base, then the ISO

packages/glouos-base/  THE source of truth for GlouOS (updatable package)
  PKGBUILD               how the package is built
  files/                 the actual files, mirroring the target filesystem:
    usr/local/bin/glou-*     update / .exe / Secure Boot tools
    usr/share/applications/  the GlouOS launchers
    usr/share/plymouth/themes/glouos/   light, branded boot splash
    etc/calamares/           the 5-step installer + light branding
    etc/skel/.config/        light theme, double-click, .exe assoc, update timer
    etc/sysctl.d, etc/modprobe.d   gaming + GPU tweaks

airootfs/              files overlaid onto the live system ("/")
  etc/pacman.conf        repos for the LIVE + INSTALLED system (multilib, [glouos])
  etc/os-release         GlouOS branding
  etc/sddm.conf.d/...    light greeter + autologin (live only)
  etc/default/grub       installed-system boot params (quiet splash)
  root/customize_airootfs.sh   build-time chroot setup (live user, zram, hooks)
efiboot/ grub/ syslinux/  bootloader menus (rebranded)

tools/                    maintainer signing tools (key gen, repo + ISO signing)
keyring/glouos-keyring/   the glouos-keyring package (ships the trusted key)
docs/UPDATES.md           how the GUI update system works
docs/AUTHENTICITY.md      how installs/updates are verified as genuine GlouOS
test-qemu.sh              boot the ISO in QEMU safely
```

---

## How to build (on an Arch host)

You need an Arch Linux environment. Easiest safe option: **Arch in a VM**.

1. Install Arch in a VM (VirtualBox/Hyper-V/QEMU), or use an existing Arch box.
2. Install the build tools:
   ```bash
   sudo pacman -S archiso base-devel qemu-desktop edk2-ovmf
   ```
3. Copy this whole `Glou/` folder into the Arch VM (shared folder, scp, git).
4. Build (as a normal user, not root):
   ```bash
   ./build.sh
   ```
   This first builds the `glouos-base` package, then the ISO. It lands in `./out/`.

### Enabling the graphical installer (Calamares)

The light Calamares config, branding and 5-step flow are already in
`packages/glouos-base/files/etc/calamares/`. You just need the `calamares`
package, which isn't in the official Arch repos:
1. Enable Chaotic-AUR on the build host (commands are in `pacman.conf`).
2. Uncomment the `[chaotic-aur]` block in both `pacman.conf` (build) and
   `airootfs/etc/pacman.conf` (target).
3. Uncomment the `calamares` lines in `packages.x86_64`.

Then "Install GlouOS" appears on the live desktop and in the menu. Until you
enable it, the ISO still includes `archinstall` (text installer) as a fallback.

---

## How to test SAFELY

Never test on real hardware first. Two layers:

1. **VM (do this first).** After building, on the Arch host run:
   ```bash
   ./test-qemu.sh
   ```
   It boots the ISO in QEMU with a **throwaway 40 GB virtual disk**, so you can
   even dry-run the installer without risking any real data. Take a VM snapshot
   before installing so you can roll back and retry instantly.

2. **Live USB on spare hardware (later).** Write `out/*.iso` to a USB stick with
   [Ventoy](https://www.ventoy.net) (just copy the ISO onto it) or Rufus, and
   boot a **non-critical** machine. A live session runs in RAM and won't touch
   the disk unless you run the installer.

---

## Windows-like behaviour (what's wired up)

- **Double-click an `.exe` or `.msi`** and it runs through Wine automatically.
  The handler is `glou-run-exe`, set as the default for Windows executables in
  `etc/skel/.config/mimeapps.list`. First run sets up an isolated Wine prefix in
  `~/.local/share/glou/wine` with a friendly progress dialog.
- **Double-click to open** files and folders (not KDE's single-click default).
- **Window buttons** (minimize / maximize / close) sit on the **right**, app menu
  on the left, like Windows.
- **Aero-style snapping**: drag a window to a screen edge to tile it.
- **Light mode** by default across desktop, login and installer.
- **Terminal** is present but plainly named "Terminal" and rarely needed.

### About the placeholder art

`branding/glouos/logo.svg`, `welcome.svg` and `slide1-3.svg` are **placeholders**
(they say so on them). Drop your real logo and screenshots in at those paths,
keeping the filenames, and the installer + desktop launcher pick them up.

### Honest limit: taskbar / desktop right-click menus

Making Plasma's right-click menus *identical* to Windows isn't something a config
file fully delivers. What's set here gets you close (light theme, familiar layout,
double-click, window buttons, snapping). For a pixel-faithful Windows feel,
configure a Windows-like Plasma global theme/layout once in a test VM, then copy
the resulting `~/.config/plasma-org.kde.plasma.desktop-appletsrc` and friends into
`packages/glouos-base/files/etc/skel/.config/`.

## Customizing

Most of GlouOS lives in the `glouos-base` package, so edits there are also what
you ship to existing users as updates (see `packages/glouos-base/README.md`).

- **Apps offered in the installer:** edit `packages/glouos-base/files/etc/calamares/netinstall-packages.yaml`.
- **GPU driver options:** edit `packages/glouos-base/files/etc/calamares/netinstall-drivers.yaml`.
- **Gaming tuning:** edit `packages/glouos-base/files/etc/sysctl.d/99-glouos-gaming.conf`.
- **Installer branding / placeholder art:** `packages/glouos-base/files/etc/calamares/branding/glouos/`.
- **Always-installed packages (from repos):** edit `packages.x86_64`.
- **Distro branding:** edit `airootfs/etc/os-release` and the bootloader titles.

---

## Important notes / honesty

- The **bootloader files** here are adapted from the official `releng` profile.
  archiso changes over time - if a boot path misbehaves, compare against the
  canonical copy on your build host at `/usr/share/archiso/configs/releng/`.
- The **Packages and Drivers steps need internet** during install (they download
  from the Arch repos). The base desktop still installs offline.
- This is a starting point, not a finished release - expect to iterate in QEMU.
