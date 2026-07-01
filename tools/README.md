# GlouOS maintainer tools - signing and authenticity

These scripts set up the cryptographic identity of GlouOS, so installs and updates
can be verified as genuine (see [../docs/AUTHENTICITY.md](../docs/AUTHENTICITY.md)).
They run on the **maintainer's machine**, not on user systems.

Make them executable first: `chmod +x tools/*.sh`

## One-time: create the signing key

```bash
tools/make-signing-key.sh "GlouOS Package Signing" keys@glouos.example
```

Do this on a secure, ideally offline machine. It:
- generates a 4096-bit signing key,
- exports the public key into `keyring/glouos-keyring/glouos.gpg`,
- writes the fingerprint into `keyring/glouos-keyring/glouos-trusted`,
- prints the fingerprint to **publish widely** (site, repo, socials, keyservers).

Keep the private key safe. For production, protect it with a passphrase or a
hardware token and store it offline.

## Build the keyring package

Once the key exists:

```bash
cd keyring/glouos-keyring && makepkg -f
```

This produces `glouos-keyring-*.pkg.tar.zst`. Add it to your `[glouos]` repo and
uncomment `glouos-keyring` in `../packages.x86_64` so every GlouOS system ships
with the trusted key and verifies updates automatically.

## Build and sign the repo

```bash
tools/build-repo.sh /srv/glouos/x86_64 keys@glouos.example
```

Detached-signs every `*.pkg.tar.zst` and builds a signed `glouos.db`. Host that
directory over HTTPS, create `/etc/pacman.d/glouos-mirrorlist`, then uncomment the
`[glouos]` block in `../airootfs/etc/pacman.conf`.

## Sign each released ISO

```bash
tools/sign-iso.sh out/glouos-2026.06.30-x86_64.iso keys@glouos.example
```

Produces `.sha256` (integrity) and `.sig` (authenticity). Publish all three.
Users verify with `gpg --verify <iso>.sig <iso>`.

## Secure Boot (user side)

No maintainer script needed - it is shipped as the **Secure Boot Setup** app
(`packages/glouos-base/files/usr/local/bin/glou-secureboot`), a light, Windows-style wizard that
uses `sbctl` to create keys, enroll them, and sign the bootloader + kernel on the
user's own machine. After setup, sbctl's pacman hook keeps things signed across
kernel updates.

## The order, end to end

1. `make-signing-key.sh`  -> key + public keyring files
2. `makepkg` in `keyring/glouos-keyring`  -> `glouos-keyring` package
3. `build-repo.sh`  -> signed `[glouos]` repo (host it)
4. enable `[glouos]` + `glouos-keyring` in the profile, build the ISO
5. `sign-iso.sh`  -> signed ISO for download
6. users verify the ISO, install, and every `pacman -Syu` is signature-checked
