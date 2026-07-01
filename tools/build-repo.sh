#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${1:?usage: build-repo.sh <dir-with-.pkg.tar.zst> [keyid-or-email]}"
KEYID="${2:-}"

cd "$REPO_DIR"
shopt -s nullglob
PKGS=( *.pkg.tar.zst )
[ ${#PKGS[@]} -gt 0 ] || { echo "No .pkg.tar.zst packages found in $REPO_DIR"; exit 1; }

echo "==> Signing ${#PKGS[@]} package(s)..."
for p in "${PKGS[@]}"; do
    gpg --detach-sign --yes ${KEYID:+-u "$KEYID"} "$p"
done

echo "==> Building signed repo database 'glouos'..."
repo-add --sign ${KEYID:+--key "$KEYID"} glouos.db.tar.gz "${PKGS[@]}"

echo
echo "==> Done. Host $REPO_DIR over HTTPS and create a mirrorlist:"
echo "      /etc/pacman.d/glouos-mirrorlist  ->  Server = https://repo.glouos.example/\$arch"
echo "    then uncomment the [glouos] block in airootfs/etc/pacman.conf."
