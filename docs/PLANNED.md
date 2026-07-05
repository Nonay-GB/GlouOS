# GlouOS — planned QoL & optimization work

Prioritized backlog agreed with the maintainer. Constraints that shape it:
no CachyOS artifacts (we compete), no over-tuning that risks undoing existing
optimizations, and the deliberate-skip list in `OPTIMIZATIONS.md` stays
authoritative.

## P1 — Reliability (motivated by the 7.1.2 kernel lockout)

| Item | What | Impact | Effort | Risk |
|---|---|---|---|---|
| Stock-kernel pin | Pacman hook reinstalls stock `[extra]` linux-zen(+headers) whenever an ALHP rebuild of the kernel lands; userspace stays on ALHP | Prevents the whole "optimized-repo kernel breaks boot/login" class | S | Low |
| linux-lts fallback | Ship `linux-lts` alongside zen with GRUB entries; generalize `glou-copy-kernel`, `initcpio.conf`, grubcfg to two kernels | A broken zen update can never lock the user out again | M | Medium (touches fragile kernel-copy path — own tested change) |
| Update sanity hook | After kernel transactions: verify kernel+initramfs+firmware landed coherently; loud notification if not | Catches partial upgrades before reboot | S | Low |
| Friendlier faillock | `/etc/security/faillock.conf`: deny=5, unlock_time=60 | Session-crash loops no longer escalate into account lockouts | S | Low |

## P2 — Gaming polish

| Item | What | Impact | Effort | Risk |
|---|---|---|---|---|
| game-devices-udev | Ship controller udev rules (DualSense, Switch, 8BitDo, wheels…) from chaotic | Controllers Just Work without Steam running | S | Low |
| systemd-oomd | Enable with conservative swap/memory-pressure policy on `background.slice` first | No more hard freezes under memory pressure (shader compiles on 8–16 GB machines) | S | Low-med (tune before default) |
| Gamescope HDR | `--hdr-enabled` in the Big Picture session when the display reports HDR | HDR in the console-style session | S | Low (guarded) |
| linux-glou kernel | See `ROADMAP-linux-glou.md` — the flagship next-release item | Last raw-FPS gap vs build-farm distros + branding | L | Medium |

## P3 — QoL

| Item | What | Impact | Effort |
|---|---|---|---|
| Boot-entry cleaner | Small UI over `efibootmgr` to list/remove stale UEFI entries (with a "don't remove current" guard) | The maintainer personally hit a stale entry after replacing a partition | S |
| Flatpak in updates | `glouos update` also runs `flatpak update --noninteractive` | Catalog apps (Discord, Sober, …) stay current with one command | S |
| Package Manager polish | App descriptions, icons, category headers, installed-state badges | Nicer first impression of yesterday's new app | M |
| Wiki sync | Fix ext4-default claim (Btrfs is default); soften "multiple kernels" until linux-lts lands | Docs stop overclaiming | S |

## Tracked, nothing to do

- **NTsync** — the zen kernel already ships the module; Proton enables it as it
  matures. Revisit only if a manual env toggle becomes worthwhile.

## Still deliberately not doing

Mass package rebuilds (ALHP covers it), own Proton builds, mesa-git, deep
C-state hacks, malloc preloads, further network tuning, >2 kernel flavours.
