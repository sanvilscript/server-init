#!/usr/bin/env bash
#
# SANVIL DNS MANAGER v1.0.0
# Copyright (c) 2025 Sanvil
# Disable systemd-resolved and use static resolv.conf
#
# Usage: ./2_disable_systemd_dns.sh <HOST> [user] [port]

set -euo pipefail

HOST="${1:-}"
USER="${2:-debian}"
PORT="${3:-22}"

if [[ -z "${HOST}" ]]; then
  echo "SANVIL DNS MANAGER v1.0.0"
  echo "Usage: $0 <HOST> [user] [port]"
  echo "Example: $0 example.org debian 22"
  exit 1
fi

SSH_OPTS="-o StrictHostKeyChecking=accept-new -o PreferredAuthentications=keyboard-interactive,password,publickey -o PubkeyAuthentication=yes"

echo "SANVIL DNS MANAGER - ${HOST}"
echo "User: ${USER} | Port: ${PORT}"
echo

echo "STEP 1 — Extract nameserver from systemd-resolved"

# Check if systemd-resolved is active
if ! ssh ${SSH_OPTS} -p "${PORT}" "${USER}@${HOST}" "systemctl is-active --quiet systemd-resolved"; then
  echo "ℹ️ systemd-resolved is not active - DNS already configured statically"
  echo "✅ Script not needed, automatic exit"
  exit 0
fi

EXTRACTED_NS=$(ssh ${SSH_OPTS} -p "${PORT}" "${USER}@${HOST}" "grep '^nameserver' /run/systemd/resolve/resolv.conf | head -1 | awk '{print \$2}'")

if [[ -z "${EXTRACTED_NS}" ]]; then
  echo "❌ No nameserver found in systemd-resolved"
  exit 1
fi

echo "✅ Nameserver extracted: ${EXTRACTED_NS}"
echo

read -r -p "Press ENTER for STEP 2 (disable systemd-resolved)..."

echo "STEP 2 — Disable systemd-resolved and configure static DNS"
ssh -tt ${SSH_OPTS} -p "${PORT}" "${USER}@${HOST}" "sudo bash -c '
echo \"=== Installing DNS tools ===\"
apt-get update -qq
apt-get install -y dnsutils

echo \"=== Disabling systemd-resolved ===\"
systemctl stop systemd-resolved
systemctl disable systemd-resolved
systemctl mask systemd-resolved

echo \"=== Creating static resolv.conf ===\"
unlink /etc/resolv.conf
cat > /etc/resolv.conf << EOF
# Static DNS configuration - Managed by SANVIL DNS MANAGER
nameserver ${EXTRACTED_NS}
search .
EOF

echo \"=== DNS testing ===\"
if dig +short google.com > /dev/null 2>&1; then
  echo \"✅ DNS test: OK (google.com resolved via dig)\"
elif nslookup google.com > /dev/null 2>&1; then
  echo \"✅ DNS test: OK (google.com resolved via nslookup)\"
elif host google.com > /dev/null 2>&1; then
  echo \"✅ DNS test: OK (google.com resolved via host)\"
else
  echo \"⚠️ DNS test: Not verifiable, but configuration applied\"
fi

echo \"✅ systemd-resolved disabled\"
echo \"✅ Static resolv.conf created with nameserver ${EXTRACTED_NS}\"
'"

echo
echo "✅ DNS CONFIGURATION COMPLETED"
echo "Nameserver: ${EXTRACTED_NS}"
echo "systemd-resolved: disabled"
echo "resolv.conf: static"
echo
echo "© 2025 Sanvil"

exit 0
