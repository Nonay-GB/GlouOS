#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYRING_DIR="$(cd "$HERE/.." && pwd)/keyring/glouos-keyring"
NAME="${1:-GlouOS Package Signing}"
EMAIL="${2:-keys@glouos.example}"

echo "==> Generating GlouOS signing key for: $NAME <$EMAIL>"
echo "    For production, protect this key with a passphrase or a hardware token"
echo "    and store the private key offline. (This script makes an unprotected key"
echo "    for convenience - edit %no-protection out below to be prompted.)"

PARAMS="$(mktemp)"
cat > "$PARAMS" <<EOF
%echo Generating GlouOS signing key
Key-Type: RSA
Key-Length: 4096
Key-Usage: sign
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: 3y
%no-protection
%commit
%echo done
EOF
gpg --batch --generate-key "$PARAMS"
rm -f "$PARAMS"

FPR="$(gpg --list-keys --with-colons "$EMAIL" | awk -F: '/^fpr:/{print $10; exit}')"

mkdir -p "$KEYRING_DIR"
gpg --export "$EMAIL" > "$KEYRING_DIR/glouos.gpg"
printf '%s:4:\n' "$FPR" > "$KEYRING_DIR/glouos-trusted"
: > "$KEYRING_DIR/glouos-revoked"

echo
echo "==> Public key exported to: $KEYRING_DIR/glouos.gpg"
echo "==> Trust written to:       $KEYRING_DIR/glouos-trusted"
echo
echo "PUBLISH THIS FINGERPRINT in several independent places so users can verify it:"
echo
echo "    $FPR"
echo
echo "Next: build the glouos-keyring package and sign your repo/ISO with this key."
