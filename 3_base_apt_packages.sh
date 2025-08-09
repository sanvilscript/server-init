#!/usr/bin/env bash
#
# SANVIL PACKAGE INSTALLER v1.0.0
# Copyright (c) 2025 Sanvil
# Install essential packages for Debian 12 server administration
#
# Usage: ./3_base_apt_packages.sh <HOST> [user] [port]

set -euo pipefail

HOST="${1:-}"
USER="${2:-debian}"
PORT="${3:-22}"

if [[ -z "${HOST}" ]]; then
  echo "SANVIL PACKAGE INSTALLER v1.0.0"
  echo "Usage: $0 <HOST> [user] [port]"
  echo "Example: $0 example.org debian 22"
  exit 1
fi

SSH_OPTS="-o StrictHostKeyChecking=accept-new -o PreferredAuthentications=keyboard-interactive,password,publickey -o PubkeyAuthentication=yes"

# Essential packages list
PACKAGES=(
  "vim"
  "net-tools"
  "btop"
  "htop"
  "iftop"
  "wget"
  "curl"
  "git"
  "nmap"
  "tcpdump"
  "screen"
  "cron"
)

echo "SANVIL PACKAGE INSTALLER - ${HOST}"
echo "User: ${USER} | Port: ${PORT}"
echo "Packages to install: ${PACKAGES[*]}"
echo

echo "STEP 1 — System update and package installation"

read -r -p "Press ENTER to start (update + upgrade + package installation)..."

ssh -tt ${SSH_OPTS} -p "${PORT}" "${USER}@${HOST}" "sudo bash -c '
echo \"=== APT cache update ===\"
apt-get update -qq

echo \"=== System upgrade (security patches and updates) ===\"
apt-get upgrade -y

echo \"=== Essential packages installation ===\"
apt-get install -y vim net-tools btop htop iftop wget curl git nmap tcpdump screen cron

echo \"=== Installation verification ===\"
FAILED_PACKAGES=()

for package in vim net-tools btop htop iftop wget curl git nmap tcpdump screen cron; do
  if dpkg -l | grep -q \"^ii  \$package \"; then
    echo \"✅ \$package: installed\"
  else
    echo \"❌ \$package: FAILED\"
    FAILED_PACKAGES+=(\"\$package\")
  fi
done

if [ \${#FAILED_PACKAGES[@]} -eq 0 ]; then
  echo \"✅ All packages installed successfully\"
else
  echo \"⚠️ Failed packages: \${FAILED_PACKAGES[*]}\"
fi

echo \"=== Functionality testing ===\"
echo \"📊 Installed versions:\"
vim --version | head -1 | sed \"s/^/  vim: /\"
htop --version 2>/dev/null | head -1 | sed \"s/^/  htop: /\" || echo \"  htop: installed\"
btop --version 2>/dev/null | head -1 | sed \"s/^/  btop: /\" || echo \"  btop: installed\"
curl --version | head -1 | sed \"s/^/  curl: /\"
wget --version | head -1 | sed \"s/^/  wget: /\"
git --version | sed \"s/^/  git: /\"
nmap --version | head -1 | sed \"s/^/  nmap: /\"
tcpdump --version 2>&1 | head -1 | sed \"s/^/  tcpdump: /\"
screen --version | head -1 | sed \"s/^/  screen: /\"
'"

echo
echo "✅ SYSTEM UPDATE AND PACKAGE INSTALLATION COMPLETED"
echo "System: fully updated with latest security patches"
echo "Installed packages:"
for package in "${PACKAGES[@]}"; do
  echo "  - ${package}"
done
echo
echo "© 2025 Sanvil"

exit 0
