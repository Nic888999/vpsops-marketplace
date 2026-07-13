#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: vps-audit.sh --host HOST --user USER [--port PORT] [--identity FILE] [--jump USER@HOST:PORT]

Runs a read-only health and security audit through SSH. It never changes the remote host.
EOF
}

host=""
user=""
port="22"
identity=""
jump=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) host="$2"; shift 2 ;;
    --user) user="$2"; shift 2 ;;
    --port) port="$2"; shift 2 ;;
    --identity) identity="$2"; shift 2 ;;
    --jump) jump="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

[[ -n "$host" && -n "$user" ]] || { usage >&2; exit 2; }

ssh_args=(-o BatchMode=yes -o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new -p "$port")
[[ -n "$identity" ]] && ssh_args+=(-i "$identity" -o IdentitiesOnly=yes)
[[ -n "$jump" ]] && ssh_args+=(-J "$jump")

ssh "${ssh_args[@]}" "$user@$host" 'bash -s' <<'REMOTE'
set -u
section() { printf '\n## %s\n' "$1"; }
as_root() {
  if [[ $(id -u) -eq 0 ]]; then
    "$@"
  else
    sudo -n "$@"
  fi
}

section "Host"
hostname
uptime -p
cat /proc/loadavg

section "Storage"
df -hT /
df -hi /
journalctl --disk-usage 2>&1 || true

section "Memory"
free -h

section "Services"
systemctl --failed --no-legend || true
for service in ssh sshd docker haproxy nginx; do
  if [[ $(systemctl show "$service.service" -p LoadState --value 2>/dev/null) == loaded ]]; then
    printf '%s: %s\n' "$service" "$(systemctl is-active "$service.service" 2>/dev/null || true)"
  fi
done

section "Privilege"
if as_root true 2>/dev/null; then
  echo "non-interactive privilege: available"
else
  echo "non-interactive privilege: unavailable; privileged checks are marked unavailable"
fi

section "Network"
as_root ss -ltnp 2>/dev/null || ss -ltn 2>/dev/null || true
as_root ufw status verbose 2>/dev/null || echo "ufw: unavailable or not installed"

section "Maintenance"
systemctl list-timers --all --no-pager 2>/dev/null | grep -E 'apt|logrotate|fstrim' || true
test -f /etc/apt/apt.conf.d/20auto-upgrades && cat /etc/apt/apt.conf.d/20auto-upgrades || true

section "Security Signals"
as_root sshd -T 2>/dev/null | grep -E 'permitrootlogin|passwordauthentication|pubkeyauthentication|allowusers|maxauthtries' || echo "sshd effective policy: unavailable"
if ssh_log=$(as_root journalctl -u ssh -u sshd --since '24 hours ago' --no-pager 2>/dev/null); then
  ssh_failure_count=$(printf '%s\n' "$ssh_log" | grep -Eic 'Failed password|Invalid user|authentication failure' || true)
  printf 'SSH failure count: %s\n' "$ssh_failure_count"
else
  echo "SSH failure count: unavailable"
fi

section "Pending Updates"
if command -v apt >/dev/null 2>&1; then
  apt list --upgradable 2>/dev/null | sed -n '1,30p' || true
elif command -v dnf >/dev/null 2>&1; then
  dnf check-update 2>/dev/null | sed -n '1,30p' || true
else
  echo "package update check: unsupported package manager"
fi
REMOTE
