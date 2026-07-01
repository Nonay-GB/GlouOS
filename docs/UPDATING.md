# GlouOS updates

GlouOS's identity (desktop layout, login theme, wallpaper, boot splash, the
`glou*`/`glouos` tools, installer branding) all live in **one package:
`glouos-base`**. Updating GlouOS therefore means shipping a new `glouos-base`
and letting installed machines pull it. This is done through **GitHub Releases**
on `github.com/Nonay-GB/GlouOS`.

The current version a machine is on is stored in `/usr/share/glouos/VERSION`,
which is written from the package's `pkgver`.

## For users: installing an update

A background service (`glouos-live-update-service`) checks the GitHub repo a few
minutes after login and every 6 hours. When a newer release exists you get a
notification. To install:

```
sudo glouos update            # update to the latest GlouOS release
sudo glouos update 0.2        # update to a specific release
```

`glouos update` updates all system packages (`pacman -Syu`), then downloads the
new `glouos-base` package from the matching GitHub release and installs it.

> New desktop *defaults* (panel layout, wallpaper) only apply to newly created
> user accounts, because they are copied from `/etc/skel` when an account is
> made. System-wide parts (login theme, tools, boot splash, `glouos` command)
> update for everyone.

## For the maintainer: publishing a release that counts as an update

1. **Make your changes** under `packages/glouos-base/files/` (or the PKGBUILD).

2. **Bump the version.** Edit `packages/glouos-base/PKGBUILD`:
   ```
   pkgver=0.2        # must be higher than the last release
   pkgrel=1
   ```
   (The `VERSION` file is written automatically from `pkgver` at build time, so
   you only change it here.)

3. **Build the package:**
   ```
   cd packages/glouos-base
   makepkg -f -d
   ```
   This produces `glouos-base-0.2-1-any.pkg.tar.zst`.

4. **(Recommended) Sign it** so pacman trusts it out of the box (the GlouOS
   keyring ships the public key). Using the GlouOS signing key created by
   `tools/make-signing-key.sh`:
   ```
   gpg --detach-sign --use-agent -u <GLOUOS_KEY_ID> glouos-base-0.2-1-any.pkg.tar.zst
   ```
   That creates `glouos-base-0.2-1-any.pkg.tar.zst.sig`. (If you skip signing,
   `glouos update` still installs it — it just isn't signature-verified.)

5. **Create the GitHub Release.** On `github.com/Nonay-GB/GlouOS` → Releases →
   *Draft a new release*:
   - **Tag:** `v0.2` (the leading `v` is optional; `0.2` works too). The tag
     name is what `glouos update` compares against the installed version.
   - **Attach** `glouos-base-0.2-1-any.pkg.tar.zst` (and the `.sig` if you signed
     it) as release **assets**.
   - Publish.

That's it — the tag makes machines see "0.2 is available", and the attached
`glouos-base` package is what they download and install.

## Shipping a whole new ISO

For changes that affect the *installer* or need a clean image (or for brand-new
installs), rebuild the ISO on an Arch host with `./build.sh` and share the
`out/*.iso`. New installs always get everything; the package-update path above is
for machines already running GlouOS.
