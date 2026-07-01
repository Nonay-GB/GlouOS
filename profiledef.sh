#!/usr/bin/env bash

iso_name="glouos"
iso_label="GLOU_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="GlouOS Project"
iso_application="GlouOS (Live/Install)"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')

bootmodes=(
  'bios.syslinux.mbr'
  'bios.syslinux.eltorito'
  'uefi-ia32.systemd-boot.esp'
  'uefi-x64.systemd-boot.esp'
  'uefi-ia32.systemd-boot.eltorito'
  'uefi-x64.systemd-boot.eltorito'
)

arch="x86_64"
pacman_conf="pacman.conf"

airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '18' '-b' '1M')

bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical')

file_permissions=(
  ["/etc/shadow"]="0:0:0400"
  ["/etc/gshadow"]="0:0:0400"
  ["/root"]="0:0:0750"
  ["/root/customize_airootfs.sh"]="0:0:0755"
)
