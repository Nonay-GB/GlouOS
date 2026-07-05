# Roadmap: `linux-glou` — the GlouOS kernel

Goal: close the last raw-performance gap vs. build-farm distros (their kernels
are arch-optimized + LTO; linux-zen is a generic GCC build) and own the most
visible piece of distro identity (`uname -r` → `*-glou`). This is the **one**
custom package worth building — mass userspace rebuilds stay with ALHP, which
already provides v3/v4 + LTO as a maintained service.

## The package

- PKGBUILD based on the zen kernel source/config (keeps the behavior our stack
  is tuned for: 1000 Hz, full preemption, fsync/futex2, sched-ext for
  `scx_lavd`, NTsync module).
- Build changes: `-march=x86-64-v3`, `-O3`, clang **thin-LTO**.
  Optionally a second `linux-glou-v4` flavour later; do not multiply variants
  beyond that.
- `pkgbase=linux-glou` so `glou-copy-kernel`, `initcpio.conf` (`kernel:`),
  and the mkinitcpio preset must be updated together — this is the fragile
  path called out in OPTIMIZATIONS.md; it gets its own tested change and a
  full VM install pass before any release.

## Distribution (must come first)

A self-shipped kernel MUST receive updates, or installs silently rot:

1. `tools/make-signing-key.sh` → signing key (exists).
2. `keyring/glouos-keyring` package (exists) → ship enabled in
   `packages.x86_64`.
3. `tools/build-repo.sh` (exists) → signed `[glouos]` pacman repo; host the
   directory as static files (GitHub Pages / R2 / any HTTPS).
4. Uncomment the `[glouos]` block in `airootfs/etc/pacman.conf`.
5. Rebuild cadence: rebuild `linux-glou` at least when zen rebases or a
   kernel CVE lands; CI (GitHub Actions) can do this on a schedule — a
   laptop-local build works but takes hours.

## Explicitly not doing

- Own Proton builds (Valve container toolchain, ~100 GB, hours per build;
  Proton-GE via protonup-qt covers it).
- Rebuilding Mesa/wine/glibc ourselves — ALHP's v3/v4 LTO builds already win
  here; duplicating them is maintenance debt with ~0% FPS.
- More than two kernel flavours. Variant sprawl is CachyOS's cost center,
  not their advantage.
