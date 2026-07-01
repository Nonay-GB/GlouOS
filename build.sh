#!/usr/bin/env bash
set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${PROFILE_DIR}/work"
OUT_DIR="${PROFILE_DIR}/out"
LOCALREPO="${WORK_DIR}/localrepo"
PKG_DIR="${PROFILE_DIR}/packages/glouos-base"
PACCONF="${PROFILE_DIR}/pacman.conf"

if [[ $EUID -eq 0 ]]; then
    echo "ERROR: run this as a normal user, not root (makepkg refuses to run as root)."
    echo "       It will call sudo for the mkarchiso step itself."
    exit 1
fi

for tool in mkarchiso makepkg repo-add; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "ERROR: '$tool' not found. Install with: sudo pacman -S archiso base-devel"
        exit 1
    }
done

echo "==> [0/3] Cleaning previous work dir..."
sudo rm -rf "$WORK_DIR"

echo "==> [1/3] Building glouos-base package..."
mkdir -p "$LOCALREPO"
( cd "$PKG_DIR" && makepkg -f --noconfirm --cleanbuild -d )
cp "$PKG_DIR"/*.pkg.tar.* "$LOCALREPO"/

VENDOR_DIR="${PROFILE_DIR}/vendor"
if compgen -G "${VENDOR_DIR}/*.pkg.tar.*" >/dev/null 2>&1; then
    echo "    + vendor packages: $(cd "$VENDOR_DIR" && ls *.pkg.tar.* | tr '\n' ' ')"
    cp "${VENDOR_DIR}"/*.pkg.tar.* "$LOCALREPO"/
fi

( cd "$LOCALREPO" && repo-add -q glouos-local.db.tar.gz ./*.pkg.tar.* )

sudo rm -f /var/cache/pacman/pkg/glouos-base-*.pkg.tar.* 2>/dev/null || true

echo "==> [2/3] Wiring up the temporary [glouos-local] repo..."
PACCONF_BACKUP="$(mktemp)"
sed -i '/# Added by build.sh/,/^Server = file:/d' "$PACCONF"
cp "$PACCONF" "$PACCONF_BACKUP"
restore_pacconf() { cp "$PACCONF_BACKUP" "$PACCONF"; rm -f "$PACCONF_BACKUP"; }
trap restore_pacconf EXIT
cat >> "$PACCONF" <<EOF

# Added by build.sh (removed automatically afterwards).
[glouos-local]
SigLevel = Never
Server = file://${LOCALREPO}
EOF

echo "==> [3/3] Building the ISO (sudo mkarchiso)..."
sudo mkarchiso -v -w "${WORK_DIR}/iso" -o "$OUT_DIR" "$PROFILE_DIR"

echo
echo "==> Done. ISO is in: $OUT_DIR"
ls -lh "$OUT_DIR"/*.iso 2>/dev/null || true
