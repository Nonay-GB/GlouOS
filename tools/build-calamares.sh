#!/usr/bin/env bash
set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENDOR_DIR="${PROFILE_DIR}/vendor"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

command -v makepkg >/dev/null || { echo "ERROR: install base-devel first."; exit 1; }

echo "==> Cloning calamares from the AUR..."
git clone --depth 1 https://aur.archlinux.org/calamares.git "$WORK/calamares"

echo "==> Building (this pulls Qt6/KF6 build deps and compiles - takes a while)..."
( cd "$WORK/calamares" && makepkg -s --noconfirm --skippgpcheck )

mkdir -p "$VENDOR_DIR"
rm -f "$VENDOR_DIR"/calamares-*.pkg.tar.*
cp "$WORK"/calamares/calamares-*.pkg.tar.* "$VENDOR_DIR"/

echo "==> Done. Vendored:"
ls -lh "$VENDOR_DIR"/calamares-*.pkg.tar.*
echo "    'calamares' is already listed in packages.x86_64, so ./build.sh will include it."
