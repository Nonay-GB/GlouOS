# vendor/

Prebuilt packages that aren't available from any binary repo and must be built
locally, then included in the ISO via the temporary `[glouos-local]` repo.

Currently: **Calamares** (the graphical installer). Build it with:

```bash
./tools/build-calamares.sh
```

That drops `calamares-*.pkg.tar.zst` here. `build.sh` automatically copies any
`*.pkg.tar.*` in this folder into the local repo, and `calamares` is listed in
`packages.x86_64`, so it gets installed into the ISO. Its dependencies come from
the official Arch repos.

The package binaries themselves are not committed (they're large and
host-specific); regenerate them with the script above.
