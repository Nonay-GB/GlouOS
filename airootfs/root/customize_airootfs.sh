#!/usr/bin/env bash
set -e -u

sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

cat > /etc/pacman.d/mirrorlist <<'EOF'
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://america.mirror.pkgbuild.com/$repo/os/$arch
EOF

systemctl mask systemd-firstboot.service

systemctl enable NetworkManager.service
systemctl enable systemd-timesyncd.service
systemctl enable fstrim.timer
systemctl set-default multi-user.target

echo "root:root" | chpasswd

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

if [ -f /etc/default/cpupower ]; then
    sed -i 's/^#governor=.*/governor="performance"/' /etc/default/cpupower || true
    systemctl enable cpupower.service 2>/dev/null || true
fi

cat > /etc/systemd/zram-generator.conf <<'EOF'
[zram0]
zram-size = min(ram, 8192)
compression-algorithm = zstd
EOF

if [ -f /etc/default/grub ]; then
    sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 nowatchdog split_lock_detect=off threadirqs amd_pstate=active"|' /etc/default/grub
fi

if [ -f /etc/default/scx ]; then
    sed -i 's/^SCX_SCHEDULER=.*/SCX_SCHEDULER=scx_lavd/' /etc/default/scx
else
    echo 'SCX_SCHEDULER=scx_lavd' > /etc/default/scx
fi
systemctl enable scx.service 2>/dev/null || true
systemctl enable openrgb.service 2>/dev/null || true
systemctl enable ananicy-cpp.service 2>/dev/null || true

for f in /etc/mkinitcpio.conf /etc/mkinitcpio.conf.d/*.conf; do
    [ -f "$f" ] || continue
    if grep -q 'HOOKS=.*udev' "$f" && ! grep -q 'HOOKS=.*plymouth' "$f"; then
        sed -i 's/\(HOOKS=([^)]*\budev\b\)/\1 plymouth/' "$f"
    fi
done

for f in /usr/share/applications/*.desktop; do
    [ -f "$f" ] || continue
    sed -i -E '/^(Name|GenericName|Comment|Keywords)(\[[^]]*\])?=/{
        s/\bKDE Plasma\b/GlouOS/g
        s/\bKDE\b/GlouOS/g
        s/\bPlasma\b/GlouOS/g
        s/\bDolphin\b/File Explorer/g
        s/\bKonsole\b/Terminal/g
    }' "$f"
done

for f in /usr/share/wayland-sessions/*.desktop /usr/share/xsessions/*.desktop; do
    [ -f "$f" ] || continue
    sed -i -E '/^(Name|GenericName|Comment)(\[[^]]*\])?=/{
        s/\bKDE Plasma\b/GlouOS/g
        s/\bKDE\b/GlouOS/g
        s/\bPlasma\b/GlouOS/g
    }' "$f"
done

for d in /usr/share/applications/calamares.desktop \
         /usr/share/applications/io.calamares.calamares.desktop; do
    [ -f "$d" ] || continue
    grep -q '^NoDisplay=' "$d" && sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$d" \
        || echo 'NoDisplay=true' >> "$d"
done

cat >> /etc/skel/.bashrc <<'EOF'

# --- GlouOS ---
if [[ $- == *i* ]]; then
    PS1='\[\e[38;5;41m\]\u@\h\[\e[0m\]:\[\e[38;5;33m\]\w\[\e[0m\]\$ '
    alias ls='ls --color=auto'
    alias ll='ls -lah --color=auto'
    alias grep='grep --color=auto'
    export EDITOR=nano
    command -v fastfetch >/dev/null 2>&1 && fastfetch
fi
EOF

echo "GlouOS airootfs customization complete."
