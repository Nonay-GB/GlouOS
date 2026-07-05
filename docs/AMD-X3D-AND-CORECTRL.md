# GlouOS on AMD: X3D Cache-Aware Gaming & CoreCtrl GPU Unlock

How GlouOS gets the most out of AMD hardware, out of the box. Both features
are automatic, hardware-gated (they do nothing on machines without the
matching hardware) and involve **no background service** — one is
event-driven, the other is a boot-time flag.

---

## 1. X3D cache-aware mode (dual-CCD Ryzen X3D CPUs)

### The problem

AMD's dual-CCD X3D processors — **Ryzen 9 7900X3D, 7950X3D and 9950X3D** —
have two different kinds of CPU cores on one chip:

| CCD | What it has | Best for |
|---|---|---|
| CCD 0 | 96 MB of stacked **3D V-Cache**, slightly lower clocks | **Games** (cache-hungry) |
| CCD 1 | Higher boost clocks, normal cache | Rendering, compiling, general work |

Games love the giant cache: when a game's threads land on the V-Cache CCD
they can gain 10–20% FPS versus running on the frequency CCD. On Windows,
AMD ships a chipset driver + "3D V-Cache Performance Optimizer" service to
steer games there. On Linux, the kernel exposes the same choice through a
sysfs knob:

```
/sys/bus/platform/drivers/amd_x3d_vcache/<device>/amd_x3d_mode
```

which accepts `cache` (prefer the V-Cache CCD) or `frequency` (prefer the
fast CCD). Most distros leave this at the firmware default and never touch
it — so games can end up scheduled on the "wrong" half of the chip.

### What GlouOS does

GlouOS switches the mode **automatically, per game session**, using the same
event-driven hook chain that powers the rest of Game Mode (GameMode's D-Bus
signal — no polling):

1. **Game starts** → GameMode fires `glou-gamemode-start` →
   `echo cache > .../amd_x3d_mode`
   Games are now steered onto the V-Cache CCD.
2. **Game exits** → GameMode fires `glou-gamemode-end` →
   `echo frequency > .../amd_x3d_mode`
   Desktop work gets the high-clock cores back.

So you get Windows-style "V-Cache optimizer" behaviour with zero
configuration, and your non-gaming workloads still enjoy the frequency CCD.

### How the pieces fit

| File | Role |
|---|---|
| `usr/local/bin/glou-gamemode-start` | writes `cache` on game start |
| `usr/local/bin/glou-gamemode-end` | writes `frequency` on game exit |
| `etc/tmpfiles.d/glouos-gaming.conf` | grants the `gamemode` group write access to the sysfs knob at boot (`z .../amd_x3d_mode 0664 root gamemode`) — the hooks run as *your user*, not root, so this is what makes the write possible |
| `etc/calamares/modules/users.conf` | installs every user into the `gamemode` group |

### Hardware gating

The `amd_x3d_vcache` sysfs device **only exists on dual-CCD X3D parts** with
a recent kernel (GlouOS ships linux-zen, which has the driver). On every
other CPU — including single-CCD X3D chips like the 7800X3D/9800X3D, which
have V-Cache on their only CCD and need no steering — the glob matches
nothing and the hooks are a no-op. There is nothing to configure and nothing
to turn off.

### Verifying it works (on a dual-CCD X3D machine)

```bash
cat /sys/bus/platform/drivers/amd_x3d_vcache/*/amd_x3d_mode   # frequency (idle)
gamemoderun sleep 5 &                                          # pretend a game is running
cat /sys/bus/platform/drivers/amd_x3d_vcache/*/amd_x3d_mode   # cache (during)
```

---

## 2. CoreCtrl unlock for AMD GPUs (`amdgpu.ppfeaturemask`)

### The problem

GlouOS bundles **CoreCtrl** — the AMD equivalent of MSI Afterburner — for
fan curves, clock control, power limits and per-GPU profiles. But by
default the `amdgpu` kernel driver **locks most of those controls away**:
its *PowerPlay feature mask* boots with overdrive (manual tuning) bits
disabled. Result on most distros: CoreCtrl opens, shows sensors, and every
interesting slider is greyed out. The user experience is "this tool is
broken."

Unlocking it requires a kernel boot parameter:

```
amdgpu.ppfeaturemask=0xffffffff
```

which enables every PowerPlay feature bit, including `PP_OVERDRIVE_MASK` —
the one that turns on manual fan/clock/voltage control.

### What GlouOS does

During installation, the hardware detection step (`glou-autodrivers`) —
the same script that picks your GPU driver stack — checks what GPUs are
present. **If an AMD GPU is detected**, it appends
`amdgpu.ppfeaturemask=0xffffffff` to `GRUB_CMDLINE_LINUX_DEFAULT` in
`/etc/default/grub`, right before the installer generates the boot menu. The
check is idempotent (it never adds the flag twice) and **machines without an
AMD GPU never get the flag at all**.

From the first boot of the installed system, CoreCtrl has full control:

- custom **fan curves** (silence at idle, airflow under load)
- **clock and voltage** control (undervolting an RDNA card is one of the
  best efficiency wins in PC gaming)
- **power limit** adjustment
- per-application GPU performance profiles

### How the pieces fit

| File | Role |
|---|---|
| `usr/local/bin/glou-autodrivers` | detects AMD GPU at install → appends the flag to `/etc/default/grub` |
| Calamares `grubcfg`/`bootloader` modules | run *after* autodrivers, so the generated `grub.cfg` includes the flag |
| `packages.x86_64` (`corectrl`) | the GUI that the unlock exists for |

### A note on safety

`ppfeaturemask=0xffffffff` only **exposes** controls — it changes no clocks,
voltages or fan behaviour by itself. Defaults stay stock until the user
moves a slider in CoreCtrl, and anything set there can be reverted in
CoreCtrl. The worst-case bad manual setting is cleared by a reboot (CoreCtrl
applies profiles at session start, which can be disabled per profile).

### Verifying it works (on an AMD GPU machine)

```bash
cat /proc/cmdline | grep -o 'amdgpu.ppfeaturemask=[^ ]*'   # flag present at boot
corectrl                                                    # fan/clock controls no longer greyed out
```

---

## Design principles (both features)

- **Hardware-gated:** each activates only when the exact hardware is
  present; on anything else it is inert, not merely "off".
- **Event-driven, never polling:** X3D switching rides GameMode's D-Bus
  signal; the GPU unlock is a boot flag. Neither adds a daemon, a timer, or
  any runtime overhead.
- **Zero configuration:** nothing to enable, no settings page to find.
  Install GlouOS on the hardware, and the hardware is used properly.
