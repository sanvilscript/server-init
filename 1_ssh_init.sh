#!/usr/bin/env bash
#
# SANVIL SSH INITIALIZER v1.0.0
# Copyright (c) 2025 Sanvil
# SSH Server Initialization Tool
#
# Usage: ./1_ssh_init.sh <HOST> [user] [current_port] [new_port]

set -euo pipefail

HOST="${1:-}"
USER="${2:-debian}"
PORT="${3:-22}"
NEW_PORT="${4:-7722}"

if [[ -z "${HOST}" ]]; then
  echo "SANVIL SSH INITIALIZER v1.0.0"
  echo "Usage: $0 <HOST> [user] [current_port] [new_port]"
  echo "Example: $0 example.org debian 22 7722"
  echo "Example: $0 example.org debian 22 2222"
  exit 1
fi

SSH_OPTS="-o StrictHostKeyChecking=accept-new -o PreferredAuthentications=keyboard-interactive,password,publickey -o PubkeyAuthentication=yes"

echo "SANVIL SSH INITIALIZER - ${HOST}"
echo "User: ${USER} | Port: ${PORT} → ${NEW_PORT}"
echo

echo "STEP 1 — User password change"
ssh -tt ${SSH_OPTS} -p "${PORT}" "${USER}@${HOST}"
RC=$?

if [[ ${RC} -ne 0 ]]; then
  echo "Session terminated with code ${RC}"
else
  echo "STEP 1 completed"
fi

echo
read -r -p "Press ENTER for STEP 2..."

echo "STEP 2 — Root configuration and SSH setup"

# Root password change
echo "Changing root password..."
ssh -tt ${SSH_OPTS} -p "${PORT}" "${USER}@${HOST}" 'sudo passwd root'

# SSH configuration
echo "Configuring SSH..."
ssh -tt ${SSH_OPTS} -p "${PORT}" "${USER}@${HOST}" "sudo bash -c '
SSHD_CFG=\"/etc/ssh/sshd_config\"
cp \"\${SSHD_CFG}\" \"\${SSHD_CFG}.backup.\$(date +%s)\"
sed -i \"/^[#[:space:]]*Port[[:space:]]/d\" \"\${SSHD_CFG}\"
sed -i \"/^[#[:space:]]*PermitRootLogin[[:space:]]/d\" \"\${SSHD_CFG}\"
echo \"Port ${NEW_PORT}\" >> \"\${SSHD_CFG}\"
echo \"PermitRootLogin yes\" >> \"\${SSHD_CFG}\"
sed -i \"/^[#[:space:]]*MACs[[:space:]]/d\" \"\${SSHD_CFG}\"
echo \"MACs umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512\" >> \"\${SSHD_CFG}\"
if systemctl list-unit-files | grep -q \"^sshd\.service\"; then
  systemctl restart sshd
else
  systemctl restart ssh
fi
echo \"SSH configured on port ${NEW_PORT}\"
echo \"MAC algorithms optimized (removed weak SHA-1/64-bit)\"
'"

echo
read -r -p "Press ENTER for STEP 3..."

echo "STEP 3 — Root connection test"
if ssh -tt ${SSH_OPTS} -p "${NEW_PORT}" "root@${HOST}" 'echo "Root connection OK"; exit'; then
  echo
  echo "✅ CONFIGURATION COMPLETED"
  echo "User: ssh -p ${NEW_PORT} ${USER}@${HOST}"
  echo "Root: ssh -p ${NEW_PORT} root@${HOST}"
  echo
  echo "© 2025 Sanvil"
else
  echo
  echo "⚠️ Connection test failed"
  echo "Manual verification: ssh -p ${NEW_PORT} ${USER}@${HOST}"
fi

exit 0
