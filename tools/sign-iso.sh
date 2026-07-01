#!/usr/bin/env bash
set -euo pipefail

ISO="${1:?usage: sign-iso.sh <file.iso> [keyid-or-email]}"
KEYID="${2:-}"

[ -f "$ISO" ] || { echo "No such file: $ISO"; exit 1; }

sha256sum "$ISO" > "$ISO.sha256"
gpg --detach-sign --yes ${KEYID:+-u "$KEYID"} "$ISO"

echo "==> Wrote:"
echo "    $ISO.sha256   (integrity)"
echo "    $ISO.sig      (authenticity - signed by the GlouOS key)"
echo
echo "Publish all three files. Users verify authenticity with:"
echo "    gpg --verify '$ISO.sig' '$ISO'"
