#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISO="$(ls -t "${HERE}"/out/*.iso 2>/dev/null | head -n1 || true)"
DISK="${HERE}/out/glouos-test.qcow2"

if [[ -z "${ISO}" ]]; then
    echo "No ISO found in ./out/ - run ./build.sh first."
    exit 1
fi

OVMF="/usr/share/edk2/x64/OVMF_CODE.4m.fd"
[[ -f "$OVMF" ]] || OVMF="/usr/share/edk2-ovmf/x64/OVMF_CODE.fd"

[[ -f "$DISK" ]] || qemu-img create -f qcow2 "$DISK" 40G

echo "==> Booting $ISO in QEMU (UEFI). Close the window to stop."
qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -m 8192 \
    -machine q35 \
    -drive if=pflash,format=raw,readonly=on,file="$OVMF" \
    -device virtio-vga-gl -display gtk,gl=on \
    -device intel-hda -device hda-duplex \
    -cdrom "$ISO" \
    -drive file="$DISK",if=virtio,format=qcow2 \
    -boot d
