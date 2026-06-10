#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Main Build Script
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -eoux pipefail for strict error handling and debugging.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

# Enable nullglob for all glob operations to prevent failures on empty matches
shopt -s nullglob

echo "::group:: Copy Bluefin Config from Common"

# Copy just files from @projectbluefin/common (includes 00-entry.just which imports 60-custom.just)
mkdir -p /usr/share/ublue-os/just/
shopt -s nullglob
cp -r /ctx/oci/common/bluefin/usr/share/ublue-os/just/* /usr/share/ublue-os/just/
shopt -u nullglob

echo "::endgroup::"

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Install Packages"

# Enabling Terra repo for noctalia-shell
dnf5 -y install --nogpgcheck \
		 --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
		 terra-release
# Disable Terra repo persistance
dnf5 -y config-manager setopt terra.enabled=0

dnf5 -y install --enablerepo=terra \
		 noctalia-shell \
		 ghostty \
		 nwg-look

# Install niri and some if it's weak deps: fontawesome-6-brands-fonts fontawesome-6-free-fonts gnome-keyring xdg-desktop-portal-gnome
# Install Noctalia's optional deps: git ImageMagick wlsunsset xdg-desktop-porta python3 evolution-data-server
dnf5 -y install --setopt=install_weak_deps=False \
		 niri \
		 fontawesome-6-brands-fonts \
		 fontawesome-6-free-fonts \
		 gnome-keyring \
		 xdg-desktop-portal-gnome \
		 git \
		 ImageMagick \
		 wlsunset \
		 xdg-desktop-portal \
		 python3 \
		 evolution-data-server \

# Terra repo cleanup
rm -f /etc/yum.repos.d/terra*.repo
dnf5 -y clean all

# Example using COPR with isolated pattern:
# copr_install_isolated "ublue-os/staging" package-name

echo "::endgroup::"

echo "::group:: System Configuration"


# Enable/disable systemd services
systemctl enable podman.socket
systemctl enable power-profiles-daemon
systemctl enable bluetooth
# TODO evolution-data-server user level services
#systemctl enable evolution-data-server
systemctl enable NetworkManager
# Actually enable the flatpak-preinstall service, so it installs the flatpaks from the defaults.preinstall file on first boot, when it has access to the internet
cp /ctx/oci/common/shared/usr/lib/systemd/system/flatpak-preinstall.service /usr/lib/systemd/system/
systemctl enable flatpak-preinstall.service

# Example: systemctl mask unwanted-service

echo "....configuring root user (root: password)...."
echo "root:password" | chpasswd

echo "::endgroup::"

echo "::group:: User Configuration"
# mkdir -p /usr/lib/sysusers.d
# cat > /usr/lib/sysusers.d/10-myuser.conf << 'EOF'
# u myuser 1000 "My User" /home/myuser /bin/bash
# EOF
useradd -m -G wheel -s /usr/sbin/bash/ myuser

mkdir -p /usr/lib/tmpfiles.d
cat > /usr/lib/tmpfiles.d/10-myuser.conf << 'EOF'
d /home/myuser 0700 myuser myuser -
EOF

mkdir -p /var/lib/systemd/linger
touch /var/lib/systemd/linger/myuser

echo "myuser:mypassword" | chpasswd

# Custom configs
cp -rf /ctx/custom/etc/* /etc

echo "::endgroup::"

# Restore default glob behavior
shopt -u nullglob

echo "Custom build complete!"
